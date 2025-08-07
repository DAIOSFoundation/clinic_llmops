// src/utils/ollamaApi.js
// Ollama Gemma3:27b API를 사용하여 의도 분석 및 텍스트 응답을 처리합니다.

const OLLAMA_BASE_URL = 'http://localhost:11434';

/**
 * Ollama API를 호출하여 사용자 입력과 제공된 의도 매핑을 기반으로 가장 유사한 의도를 식별합니다.
 * 또한, 특정 의도와 관련된 엔티티(예: 환자 이름)를 추출합니다.
 * @param {string} userMessage - 사용자의 입력 메시지
 * @param {Object} intentMapping - 의도 키와 해당 질문 목록을 포함하는 객체 (예: {"CONSULT_STEP_0": ["피부과 상담 확인"]})
 * @returns {Promise<{matched_intent: string, extracted_entities?: Object}>} - 식별된 의도 키와 추출된 엔티티 객체
 */
export const getGeminiIntent = async (userMessage, intentMapping) => {
    const intentString = JSON.stringify(intentMapping, null, 2);

    const systemPrompt = `당신은 톡스앤필(Tox&Feel) 피부과의 친절하고 전문적인 스태프입니다. 
환자와의 상호작용에서 항상 따뜻하고 이해심 있는 태도로 응답하며, 
의료 전문가로서의 전문성을 바탕으로 정확하고 도움이 되는 정보를 제공합니다.

주요 역할:
- 환자의 질문에 친절하고 전문적으로 답변
- 의료 용어를 쉽게 설명하여 환자가 이해할 수 있도록 도움
- 환자의 안녕을 진심으로 걱정하는 마음으로 응답
- 정확한 의료 정보 제공과 함께 환자의 편안함을 고려

이제 주어진 사용자 메시지와 가능한 의도 목록을 분석하여 가장 적절한 의도를 매칭해주세요.`;

    const userPrompt = `사용자 메시지: '${userMessage}'
가능한 의도의 리스트와 관련된 키워드와 문장들:
${intentString}

위 리스트 중에서 의미적으로 가장 유사한 의도를 가진 항목을 선택해주세요.
만약 사용자 메시지에 환자 이름이 포함되어 있고, 해당 환자 정보나 예약 내역 조회와 관련된 의도라면, 환자 이름을 'patient_name' 키로 추출해주세요.

JSON 형식으로만 응답해주세요:
{ "matched_intent": "INTENT_KEY", "extracted_entities": { "patient_name": "환자이름" } }

만약 적합한 의도가 매칭되지 않으면:
{ "matched_intent": "NONE" }

한국어로만 응답해주세요.`;

    try {
        const response = await fetch(`${OLLAMA_BASE_URL}/api/generate`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                model: 'gemma3:27b',
                system: systemPrompt,
                prompt: userPrompt,
                stream: false,
                options: {
                    temperature: 0.1,
                    top_p: 0.9,
                    max_tokens: 500
                }
            })
        });

        if (!response.ok) {
            throw new Error(`Ollama API error: ${response.status}`);
        }

        const data = await response.json();
        console.log("Ollama raw response for intent matching:", data.response);

        // JSON 응답 파싱
        const cleanedText = data.response.replace(/```json|```/g, '').trim();
        const jsonResponse = JSON.parse(cleanedText);
        
        // extracted_entities가 객체인지 확인
        if (jsonResponse.extracted_entities && typeof jsonResponse.extracted_entities !== 'object') {
            jsonResponse.extracted_entities = {};
        }

        return {
            matched_intent: jsonResponse.matched_intent || "NONE",
            extracted_entities: jsonResponse.extracted_entities || {}
        };
    } catch (error) {
        console.error("Error calling Ollama API for intent matching:", error);
        return { matched_intent: "ERROR", extracted_entities: {} };
    }
};

/**
 * Ollama API를 호출하여 텍스트 응답을 생성합니다.
 * @param {string} promptText - 사용자의 텍스트 입력.
 * @param {File | null} imageFile - 사용자가 첨부한 이미지 파일 (선택 사항).
 * @param {string | null} context - LLM에 제공할 추가 문맥 정보 (선택 사항).
 * @returns {Promise<{text: string, imageUrl?: string, imageMimeType?: string}>} - Ollama API의 응답 텍스트.
*/
export const getGeminiTextResponse = async (promptText, imageFile = null, context = null) => {
    try {
        console.log("🤖 LLM 응답 생성 시작 - Ollama Gemma3:27b 호출");
        
        const systemPrompt = `당신은 톡스앤필(Tox&Feel) 피부과의 친절하고 전문적인 스태프입니다.

주요 역할과 응답 스타일:
- 환자와의 상호작용에서 항상 따뜻하고 이해심 있는 태도로 응답
- 의료 전문가로서의 전문성을 바탕으로 정확하고 도움이 되는 정보 제공
- 의료 용어를 쉽게 설명하여 환자가 이해할 수 있도록 도움
- 환자의 안녕을 진심으로 걱정하는 마음으로 응답
- 정확한 의료 정보 제공과 함께 환자의 편안함을 고려
- 친근하면서도 전문적인 톤으로 응답
- 환자의 질문에 대해 구체적이고 실용적인 조언 제공

이제 환자의 질문에 대해 친절하고 전문적으로 답변해주세요.`;

        let finalPrompt = promptText;
        if (context && context.trim() !== '') {
            console.log("📄 컨텍스트 정보 포함하여 프롬프트 구성");
            finalPrompt = `[참고 정보]:\n${context}\n\n[환자 질문]:\n${promptText}`;
        } else {
            console.log("📝 컨텍스트 없이 사용자 질문만으로 프롬프트 구성");
        }

        console.log("🚀 Ollama API 호출 시작...");
        const response = await fetch(`${OLLAMA_BASE_URL}/api/generate`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                model: 'gemma3:27b',
                system: systemPrompt,
                prompt: finalPrompt,
                stream: false,
                options: {
                    temperature: 0.7,
                    top_p: 0.9,
                    max_tokens: 2000
                }
            })
        });

        if (!response.ok) {
            throw new Error(`Ollama API error: ${response.status}`);
        }

        console.log("✅ Ollama API 응답 수신 완료");
        const data = await response.json();
        console.log("📝 LLM 응답 텍스트 생성 완료:", data.response.substring(0, 100) + "...");
        
        return { 
            text: data.response, 
            imageUrl: null, 
            imageMimeType: null 
        };
    } catch (error) {
        console.error("❌ LLM 응답 생성 실패:", error);
        return { 
            text: "죄송합니다. 응답을 생성하는 중에 오류가 발생했습니다. 잠시 후 다시 시도해주세요.", 
            imageUrl: null, 
            imageMimeType: null 
        };
    }
};
