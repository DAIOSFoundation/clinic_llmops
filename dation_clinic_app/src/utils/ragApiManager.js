// src/utils/ragApiManager.js

/**
 * localStorage에서 RAG API 설정을 로드합니다.
 * @returns {Array} RAG API 설정 배열
 */
export const loadRagApis = () => {
  try {
    const saved = localStorage.getItem('ragApis');
    console.log('loadRagApis - localStorage에서 읽은 값:', saved);
    const result = saved ? JSON.parse(saved) : [];
    console.log('loadRagApis - 파싱된 결과:', result);
    return result;
  } catch (error) {
    console.error('Failed to load RAG APIs:', error);
    return [];
  }
};

/**
 * localStorage에 RAG API 설정을 저장합니다.
 * @param {Array} apis - RAG API 설정 배열
 */
export const saveRagApis = (apis) => {
  try {
    console.log('saveRagApis - 저장할 API:', apis);
    const jsonString = JSON.stringify(apis);
    console.log('saveRagApis - JSON 문자열:', jsonString);
    localStorage.setItem('ragApis', jsonString);
    console.log('saveRagApis - localStorage에 저장 완료');
  } catch (error) {
    console.error('Failed to save RAG APIs:', error);
  }
};

/**
 * 기본 RAG API를 가져옵니다.
 * @returns {Object|null} 기본 RAG API 설정 또는 null
 */
export const getDefaultRagApi = () => {
  const apis = loadRagApis();
  return apis.find(api => api.isDefault) || (apis.length > 0 ? apis[0] : null);
};

/**
 * 특정 키워드와 가장 관련성이 높은 RAG API를 찾습니다.
 * @param {string} userMessage - 사용자 메시지
 * @returns {Object|null} 가장 관련성이 높은 RAG API 또는 null
 */
export const findBestMatchingRagApi = (userMessage) => {
  const apis = loadRagApis();
  if (apis.length === 0) return null;

  // 기본 API가 있으면 우선 반환
  const defaultApi = apis.find(api => api.isDefault);
  if (defaultApi) return defaultApi;

  // 키워드 매칭을 통한 최적 API 찾기
  let bestMatch = null;
  let bestScore = 0;

  for (const api of apis) {
    if (!api.keywords || api.keywords.length === 0) continue;

    const score = api.keywords.reduce((total, keyword) => {
      const regex = new RegExp(keyword, 'gi');
      const matches = userMessage.match(regex);
      return total + (matches ? matches.length : 0);
    }, 0);

    if (score > bestScore) {
      bestScore = score;
      bestMatch = api;
    }
  }

  return bestMatch || apis[0]; // 매칭되는 것이 없으면 첫 번째 API 반환
};

/**
 * RAG API를 호출하여 관련 문서를 검색합니다.
 * @param {string} query - 검색 쿼리
 * @param {Object} ragApi - RAG API 설정
 * @returns {Promise<Object>} 검색 결과
 */
export const callRagApi = async (query, ragApi) => {
  if (!ragApi || !ragApi.url) {
    throw new Error('Invalid RAG API configuration');
  }

  try {
    // URL에서 {rag_id} 플레이스홀더를 실제 RAG ID로 교체
    let url = ragApi.url;
    if (url.includes('{rag_id}')) {
      // 실제 RAG ID를 추출하거나 기본값 사용
      const ragId = extractRagIdFromUrl(url) || 'default-rag-id';
      url = url.replace('{rag_id}', ragId);
    }

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        // 필요한 경우 인증 헤더 추가
        // 'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({
        query: query,
        // 필요한 경우 추가 파라미터
        top_k: 5,
        similarity_threshold: 0.7
      })
    });

    if (!response.ok) {
      throw new Error(`RAG API call failed: ${response.status} ${response.statusText}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error calling RAG API:', error);
    throw error;
  }
};

/**
 * URL에서 RAG ID를 추출합니다.
 * @param {string} url - RAG API URL
 * @returns {string|null} RAG ID 또는 null
 */
const extractRagIdFromUrl = (url) => {
  // URL 패턴에서 RAG ID 추출 로직
  const match = url.match(/\/retriever\/([^\/\?]+)/);
  return match ? match[1] : null;
};

/**
 * RAG API 설정을 검증합니다.
 * @param {Object} apiConfig - RAG API 설정
 * @returns {Object} 검증 결과 {isValid: boolean, errors: Array}
 */
export const validateRagApiConfig = (apiConfig) => {
  const errors = [];

  if (!apiConfig.name || apiConfig.name.trim() === '') {
    errors.push('API 이름은 필수입니다.');
  }

  if (!apiConfig.url || apiConfig.url.trim() === '') {
    errors.push('API URL은 필수입니다.');
  } else {
    try {
      new URL(apiConfig.url);
    } catch {
      errors.push('유효한 URL 형식이 아닙니다.');
    }
  }

  return {
    isValid: errors.length === 0,
    errors
  };
};

/**
 * RAG API 설정을 초기화합니다 (기본 설정).
 */
export const initializeDefaultRagApis = () => {
  console.log('initializeDefaultRagApis 시작');
  const existingApis = loadRagApis();
  console.log('기존 API 개수:', existingApis.length);
  
  if (existingApis.length === 0) {
    console.log('기본 RAG API 생성 시작');
    const defaultApis = [
      {
        id: Date.now(),
        name: '피부과 RAG API',
        url: 'http://localhost:8000/api/v1/rags/retriever/0d953f79-c621-4ed3-84dc-7542ac037553',
        keywords: ['피부', '피부과', '진료', '시술', '보톡스', '필러', '클리닉', '상담', '필러', '보톡스'],
        description: '피부과 관련 문서를 검색하는 RAG API',
        category: '피부과',
        isDefault: true,
        createdAt: new Date().toISOString()
      }
    ];
    
    console.log('저장할 기본 API:', defaultApis);
    saveRagApis(defaultApis);
    console.log('기본 RAG API 설정이 초기화되었습니다:', defaultApis);
    return defaultApis;
  }
  
  console.log('기존 RAG API 설정이 있습니다:', existingApis);
  return existingApis;
}; 