import React, { useRef, useEffect, useState, useCallback } from 'react';
import './MainContent.css';
import PromptCard from './PromptCard';
import InputBox from './InputBox';
import ReactMarkdown from 'react-markdown'; // ReactMarkdown import
import remarkGfm from 'remark-gfm'; // GitHub Flavored Markdown 지원
import rehypeRaw from 'rehype-raw'; // HTML 렌더링 지원 (필요시)
import { getGeminiTextResponse } from '../utils/ollamaApi'; // Ollama API 임포트
import { calculateSimilarity } from '../utils/textSimilarity'; // NEW: 유사도 계산 함수 임포트
import PromptExamplesPopup from './PromptExamplesPopup'; // 팝업 컴포넌트 임포트
import { loadRagApis, findBestMatchingRagApi, initializeDefaultRagApis } from '../utils/ragApiManager'; // RAG API 관리 함수 임포트

// Define API constants for RAG
const API_PROXY_PREFIX = '/api'; // The proxy prefix defined in vite.config.js

// getCategoryAndRagContext 함수를 설정된 RAG API를 사용하도록 변경
async function getCategoryAndRagContext(question, addApiCallLog) {
  const SIMILARITY_THRESHOLD = 0.8; // 유사도 임계값

  // 1. 설정된 RAG API 목록 로드
  addApiCallLog('Searching', '🔍 유사도 검색 시작...', 0, '문서 검색 준비 중');
  
  const ragApis = loadRagApis();
  console.log('MainContent에서 로드된 RAG API:', ragApis);
  console.log('localStorage ragApis:', localStorage.getItem('ragApis'));
  
  if (ragApis.length === 0) {
    addApiCallLog('API', '설정된 RAG API가 없습니다.');
    console.log('RAG API가 없어서 기본값 반환');
    return { category: '기타', ragContext: null };
  }

  addApiCallLog('API', `${ragApis.length}개의 RAG API로 카테고리 분석 중...`);
  addApiCallLog('Query', `질문: ${question}`);
  console.log('설정된 RAG API 목록:', ragApis);
  console.log('원본 질문:', question);

  // 2. 설정된 RAG API들 병렬 호출 (백엔드에서 통합된 유사도 검색 수행)
  
  const ragApiPromises = ragApis.map(async (api) => {
    try {
      let apiUrl = api.url;
      
      // URL 검증 및 수정
      console.log('처리 전 API URL:', apiUrl);
      
      // 개발 환경에서 localhost:8000 URL을 프록시를 통해 호출
      if (import.meta.env.DEV && apiUrl.includes('localhost:8000')) {
        apiUrl = apiUrl.replace('http://localhost:8000', API_PROXY_PREFIX);
      }
      
      // 상대 URL인 경우 절대 URL로 변환
      if (apiUrl.startsWith('/')) {
        apiUrl = `${window.location.origin}${apiUrl}`;
      }
      
      console.log('처리 후 API URL:', apiUrl);
      
      // 한국어 인코딩 개선: URLSearchParams 사용
      const url = new URL(apiUrl);
      url.searchParams.set('question', question); // 원본 질문 그대로 전달
      
      console.log(`RAG API 호출 URL: ${url.toString()}`);
      const response = await fetch(url.toString());
      
      // HTTP 상태 코드 확인
      if (!response.ok) {
        console.error(`RAG API 호출 실패 (${api.name}): HTTP ${response.status} ${response.statusText}`);
        return { api, data: null, success: false, error: `HTTP ${response.status}` };
      }
      
      // 응답이 비어있는지 확인
      const responseText = await response.text();
      if (!responseText || responseText.trim() === '') {
        console.error(`RAG API 호출 실패 (${api.name}): 빈 응답`);
        return { api, data: null, success: false, error: '빈 응답' };
      }
      
      // JSON 파싱
      let data;
      try {
        data = JSON.parse(responseText);
      } catch (parseError) {
        console.error(`RAG API JSON 파싱 실패 (${api.name}):`, parseError, 'Response:', responseText);
        return { api, data: null, success: false, error: 'JSON 파싱 실패' };
      }
      
      addApiCallLog('RAG', `✅ ${api.name} API 호출 성공`, 0, `카테고리: ${api.category}`);
      
      return { api, data, success: true };
    } catch (error) {
      console.error(`RAG API 호출 실패 (${api.name}):`, error);
      addApiCallLog('RAG', `❌ ${api.name} API 호출 실패`, 0, `오류: ${error.message}`);
      return { api, data: null, success: false, error: error.message };
    }
  });

  const ragApiResults = await Promise.all(ragApiPromises);
  console.log('RAG API 호출 결과:', ragApiResults);

  // 응답 조립 시작 로그
  addApiCallLog('Assembling', '🔧 응답 조립 중...', 0, '데이터 처리 및 응답 생성');

  // 3. 결과 분석 및 카테고리 결정

  // 4. 최대 유사도 추출 함수
  const getMaxSimilarity = (data) => {
    if (!data?.data?.documents?.length) return 0;
    return Math.max(...data.data.documents.map(doc => doc.score || 0));
  };

  // 5. 성공한 API 중에서 최고 유사도 찾기
  const successfulResults = ragApiResults.filter(result => result.success);
  let bestResult = null;
  let maxSimilarity = 0;

  successfulResults.forEach(result => {
    const similarity = getMaxSimilarity(result.data);
    if (similarity > maxSimilarity) {
      maxSimilarity = similarity;
      bestResult = result;
    }
  });

  let category = '기타';
  let ragContext = null;
  let ragData = null;

  // 5. 유사도 기반 카테고리 결정
  if (maxSimilarity >= SIMILARITY_THRESHOLD && bestResult) {
    category = bestResult.api.category || '기타';
    ragData = bestResult.data;
    addApiCallLog('Result', `🎯 최종 카테고리: ${category}`, maxSimilarity, `${bestResult.api.name} (유사도: ${maxSimilarity.toFixed(2)})`);
  } else {
    // 6. 키워드 기반 매칭으로 폴백
    const bestMatchingApi = findBestMatchingRagApi(question);
    if (bestMatchingApi) {
      category = bestMatchingApi.category || '기타';
      // 이미 호출한 결과에서 찾기
      const matchingResult = ragApiResults.find(result => result.api.id === bestMatchingApi.id);
      if (matchingResult && matchingResult.success) {
        ragData = matchingResult.data;
      }
      addApiCallLog('Result', `🔍 키워드 기반 카테고리: ${category}`, 0, `${bestMatchingApi.name}`);
    } else {
      addApiCallLog('Result', `⚠️ 카테고리 분석 실패`, 0, '기본값 사용');
    }
  }

  // 7. 컨텍스트 추출 및 출처 로그 기록
  addApiCallLog('Searching', '📄 컨텍스트 추출 중...', 0, '관련 문서 내용 정리');
  
  if (ragData?.data?.documents?.length > 0) {
    // 컨텍스트 최적화: 각 문서의 내용을 요약하고 길이 제한
    const optimizedDocs = ragData.data.documents.map(doc => {
      let content = doc.page_content;
      
      // 문서 내용이 너무 길면 잘라내기 (각 문서당 최대 500자)
      if (content.length > 500) {
        content = content.substring(0, 500) + '...';
      }
      
      // 줄바꿈을 공백으로 변환하여 가독성 개선
      content = content.replace(/\n+/g, ' ').trim();
      
      return content;
    });
    
    // 상위 3개 문서만 사용 (유사도가 높은 문서들)
    const topDocs = optimizedDocs.slice(0, 3);
    ragContext = topDocs.join('\n\n---\n\n');
    
    addApiCallLog('Context', `📄 ${topDocs.length}개 문서 추출 완료`, 0, `총 ${ragContext.length}자 (최적화됨)`);
    
    // 상위 3개 문서만 Source 로그에 표시
    ragData.data.documents.slice(0, 3).forEach((doc, index) => {
      if (doc.metadata?.source) {
        addApiCallLog('Source', `📎 문서 ${index + 1}`, doc.score, `출처: ${doc.metadata.source}`, doc.page_content, doc.metadata.file_url);
      }
    });
  } else {
    addApiCallLog('Context', `⚠️ 관련 문서 없음`, 0, '컨텍스트 없음');
  }
  
  // 8. 검색 완료
  addApiCallLog('Searching', '✅ RAG 검색 완료!', 0, '모든 단계 완료');
  
  return { category, ragContext };
}

// addApiCallLog, clearSourceLogs, updateApiCallLog, setLastLlmOutput prop을 추가
function MainContent({ chatHistory, setChatHistory, currentPromptInput, setCurrentPromptInput, promptsTemplates, handleSaveChat, addApiCallLog, clearSourceLogs, setLastLlmOutput }) { // MODIFIED: updateApiCallLog prop 제거
  const messagesEndRef = useRef(null);
  const inputRef = useRef(null);
  const [isLoading, setIsLoading] = useState(false);
  const [pastedImage, setPastedImage] = useState(null); // 추가: 클립보드 이미지 상태

  // 팝업 상태 추가
  const [isPopupOpen, setIsPopupOpen] = useState(false);
  const [popupPrompt, setPopupPrompt] = useState(null);

  // RAG API 초기화
  useEffect(() => {
    console.log('MainContent 마운트 - RAG API 초기화 시작');
    const apis = loadRagApis();
    console.log('MainContent에서 로드된 RAG API:', apis);
    
    if (apis.length === 0) {
      console.log('MainContent에서 기본 RAG API 초기화');
      initializeDefaultRagApis();
    } else {
      console.log('설정된 RAG API 사용:', apis);
    }
  }, []);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
    if (!isLoading) {
      inputRef.current?.focus();
    }
  }, [chatHistory, isLoading]);

  // --- Ctrl+S 저장 단축키 로직 추가 ---
  useEffect(() => {
    const handleKeyDown = (e) => {
      // Ctrl+S (Windows/Linux) 또는 Cmd+S (macOS) 확인
      if (e.key === 's' && (e.ctrlKey || e.metaKey)) {
        e.preventDefault(); // 브라우저의 기본 저장 대화 상자 방지
        handleSaveChat(chatHistory); // 챗 저장 함수 호출
      }
    };

    window.addEventListener('keydown', handleKeyDown);

    // 컴포넌트 언마운트 시 이벤트 리스너 제거
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [handleSaveChat, chatHistory]); // handleSaveChat과 chatHistory를 의존성 배열에 추가

  // 이미지 붙여넣기 핸들러 (InputBox에서 호출됨)
  const handlePasteImage = useCallback((imageFile, imageUrl) => {
    setPastedImage({ file: imageFile, url: imageUrl });
  }, []);

  // 이미지 제거 핸들러 (InputBox에서 호출됨)
  const handleClearImage = useCallback(() => {
    setPastedImage(null);
  }, []);

  const handleSendMessage = async () => {
    if (currentPromptInput.trim() === '' && !pastedImage || isLoading) return;

    // 새 질의 시 기존 'Source' 타입 로그 초기화
    clearSourceLogs();
    setLastLlmOutput(''); // NEW: 새 질의 시작 시 이전 LLM 출력 초기화

    // 대화 기록에 사용자 메시지 추가 (이미지 포함)
    const userMessage = { 
      role: 'user', 
      text: currentPromptInput.trim(),
      ...(pastedImage && { image: { url: pastedImage.url, file: pastedImage.file } }) // 이미지 데이터 추가
    };
    setChatHistory((prev) => [...prev, userMessage]);
    setCurrentPromptInput('');
    setPastedImage(null); // 이미지 전송 후 초기화
    setIsLoading(true);

    const llmLogId = addApiCallLog('LLM', 'LLM이 사용자 질의를 분석 중입니다.'); // LLM 로그 ID 저장

    let ragContext = null; // RAG API로부터 얻을 context
    // MODIFIED: Use the new getRagApiUrl function to construct the fetch URL
    const { category, ragContext: fetchedRagContext } = await getCategoryAndRagContext(userMessage.text, addApiCallLog);
    ragContext = fetchedRagContext;

    try {
      addApiCallLog('API', '관련 자료 검색 중...');
      
      // LLM 응답 생성 시작
      addApiCallLog('LLM', '🤖 LLM 응답 생성 시작...', 0, 'Ollama Gemma3:27b 모델 호출');
      
      // ragContext가 null이면 Gemini에 context 없이 질문만 전달
      const geminiResponse = await getGeminiTextResponse(userMessage.text, userMessage.image?.file, ragContext);
      
      const modelMessage = {
        role: 'model',
        text: geminiResponse.text,
      };

      // LLM 응답에 이미지가 포함되어 있을 경우 메시지 객체에 추가
      if (geminiResponse.imageUrl) {
        modelMessage.image = {
          url: geminiResponse.imageUrl,
          mimeType: geminiResponse.imageMimeType,
        };
      }

      setChatHistory((prev) => [...prev, modelMessage]);
      
      // LLM 응답 완료
      addApiCallLog('LLM', '✅ LLM 응답 생성 완료!', 0, `총 ${geminiResponse.text.length}자 응답`);
      
      // 응답 조립 완료 로그 (실제 응답이 화면에 표시된 후)
      addApiCallLog('Assembling', '✅ 응답 조립 완료!', 0, '최종 응답 화면 표시 완료');
      
      // LLM 카드는 응답 완료 시 사라지도록 상태 변경 (이제 App.jsx에서 자동 처리되므로 제거)
      // updateApiCallLog(llmLogId, 'fading-out', 'LLM이 응답을 생성했습니다.'); 
      setLastLlmOutput(geminiResponse.text); // NEW: 최종 LLM 응답을 App.jsx로 전달
      // 시뮬레이션된 출처 로그 추가 (기존 시뮬레이션은 RAG에서 처리되므로 제거)
      
      // addApiCallLog('Source', '🧇 답변 출처: "2024년 1월 생산 보고서"');

    } catch (error) {
      console.error('Error calling Gemini API:', error);
      
      // LLM 응답 생성 실패
      addApiCallLog('LLM', '❌ LLM 응답 생성 실패', 0, `오류: ${error.message}`);
      
      setChatHistory((prev) => [...prev, { role: 'model', text: '죄송합니다. 메시지를 처리하는 데 문제가 발생했습니다. 다시 시도해 주세요.' }]);
      
      // 응답 조립 완료 로그 (에러 발생 시에도)
      addApiCallLog('Assembling', '✅ 응답 조립 완료!', 0, '에러 응답 화면 표시 완료');
      
      // LLM 카드는 에러 발생 시에도 사라지도록 상태 변경 (이제 App.jsx에서 자동 처리되므로 제거)
      // updateApiCallLog(llmLogId, 'fading-out', 'LLM 응답 생성 실패'); 
      setLastLlmOutput('LLM 응답 생성 실패'); // NEW: 에러 발생 시에도 LLM 출력 상태 업데이트
    } finally {
      setIsLoading(false);
      inputRef.current?.focus();
    }
  };

  const handlePromptCardClick = (prompt) => {
    setPopupPrompt(prompt);
    setIsPopupOpen(true);
  };

  // promptsTemplates 배열을 수정하여 '식당 예약' 프롬프트를 '톡스앤필 상담' 프롬프트로 교체
  // const updatedPromptsTemplates = promptsTemplates.map(prompt => {
  //   if (prompt.title === '식당 예약') {
  //     return {
  //       ...prompt,
  //       title: '톡스앤필 상담',
  //       description: '톡스앤필 피부과 클리닉의 일반 정보, 시술 정보, 예약을 도와주는 프롬프트 입니다.',
  //       example: '필러 보톡스 상담받고 싶어. 국산이랑 외산 제품이 비용차이가 얼마나 나고 왜 나는지 궁금해. 그리고 필러 보톡스 맞았을지 유지 기간이 얼마나 되는지 궁금해.'
  //     };
  //   }
  //   return prompt;
  // });

  // 제거할 프롬프트 목록
  const promptsToRemove = [
    '식당 예약'
  ];
  
  // 제거할 프롬프트들을 필터링하고, '톡스앤필 상담' 프롬프트를 추가
  const filteredPrompts = promptsTemplates.filter(prompt => 
    !promptsToRemove.some(removeTitle => 
      prompt.title && prompt.title.includes(removeTitle)
    )
  );
  
  const toksnfillPrompt = {
    id: 'toksnfill-consult',
    title: '톡스앤필 상담',
    description: '톡스앤필 피부과 클리닉의 일반 정보, 시술 정보, 예약을 도와주는 프롬프트 입니다.',
    example: '필러 보톡스 상담받고 싶어. 국산이랑 외산 제품이 비용차이가 얼마나 나고 왜 나는지 궁금해. 그리고 필러 보톡스 맞았을지 유지 기간이 얼마나 되는지 궁금해.',
    category: 'General',
    author: 'You',
    date: new Date().toISOString().split('T')[0] // 오늘 날짜로 설정
  };
  const finalPrompts = [...filteredPrompts, toksnfillPrompt];

  return (
    <div className="main-content-container">
      <div className="chat-messages-display">
        {chatHistory.length === 0 ? (
          <div className="no-messages">
            <p>메시지를 입력하여 대화를 시작해 보세요!</p>
          </div>
        ) : (
          chatHistory.map((msg, index) => (
            <div key={index} className={`chat-message ${msg.role}`}>
              <div className="message-bubble">
                {msg.image && ( // 이미지가 있을 경우 썸네일 표시
                  <div className="message-image-container">
                    <img src={msg.image.url} alt={msg.role === 'user' ? "Pasted" : "Generated"} className="message-image-thumbnail" />
                  </div>
                )}
                {/* ReactMarkdown을 사용하여 마크다운 렌더링 */}
                <ReactMarkdown remarkPlugins={[remarkGfm]} rehypePlugins={[rehypeRaw]}>
                  {msg.text}
                </ReactMarkdown>
              </div>
            </div>
          ))
        )}
        {isLoading && (
          <div className="chat-message model loading">
            <div className="message-bubble loading-dots">
              <span></span><span></span><span></span>
            </div>
          </div>
        )}
        <div ref={messagesEndRef} />
      </div>

      <div className="prompts-section">
        <h2>Prompts</h2>
        <div className="prompts-grid">
          {finalPrompts.map((prompt) => (
            <PromptCard
              key={prompt.id}
              prompt={prompt}
              onClick={handlePromptCardClick}
              isSelected={false} // 선택 상태 비활성화
            />
          ))}
        </div>
      </div>

      <InputBox
        value={currentPromptInput}
        onChange={(e) => setCurrentPromptInput(e.target.value)}
        onSend={handleSendMessage}
        isLoading={isLoading}
        placeholder="How can I help you?"
        inputRef={inputRef}
        pastedImage={pastedImage} // 추가: pastedImage prop 전달
        onPasteImage={handlePasteImage} // 추가: onPasteImage prop 전달
        onClearImage={handleClearImage} // 추가: onClearImage prop 전달
      />

      {isPopupOpen && popupPrompt && (
        <PromptExamplesPopup
          title={popupPrompt.title}
          examples={popupPrompt.example}
          onClose={() => setIsPopupOpen(false)}
        />
      )}
    </div>
  );
}

export default MainContent;