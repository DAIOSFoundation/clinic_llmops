// src/components/RagSettingsPage.jsx
import React, { useState, useEffect } from 'react';
import './RagSettingsPage.css';
import { 
  loadRagApis, 
  saveRagApis, 
  validateRagApiConfig,
  initializeDefaultRagApis 
} from '../utils/ragApiManager';

function RagSettingsPage() {
  const [ragApis, setRagApis] = useState([]);
  const [newApi, setNewApi] = useState({
    name: '',
    url: '',
    keywords: '',
    description: '',
    category: '기타'
  });
  const [editingId, setEditingId] = useState(null);
  const [isAddingNew, setIsAddingNew] = useState(false);
  const [validationErrors, setValidationErrors] = useState([]);

  // 컴포넌트 마운트 시 저장된 RAG API 설정 로드
  useEffect(() => {
    console.log('RagSettingsPage 마운트됨');
    const apis = loadRagApis();
    console.log('로드된 RAG API:', apis);
    
    if (apis.length === 0) {
      // 기본 설정이 없으면 초기화
      console.log('기본 RAG API 초기화 시작');
      const defaultApis = initializeDefaultRagApis();
      console.log('초기화된 기본 RAG API:', defaultApis);
      setRagApis(defaultApis);
    } else {
      setRagApis(apis);
    }
  }, []);

  // 새 RAG API 추가
  const handleAddApi = () => {
    // 유효성 검사
    const validation = validateRagApiConfig(newApi);
    if (!validation.isValid) {
      setValidationErrors(validation.errors);
      return;
    }

    setValidationErrors([]);

    const apiToAdd = {
      id: Date.now(),
      ...newApi,
      keywords: newApi.keywords.split(',').map(k => k.trim()).filter(k => k),
      createdAt: new Date().toISOString()
    };

    const updatedApis = [...ragApis, apiToAdd];
    setRagApis(updatedApis);
    saveRagApis(updatedApis);
    
    // 폼 초기화
    setNewApi({ name: '', url: '', keywords: '', description: '', category: '기타' });
    setIsAddingNew(false);
  };

  // RAG API 수정
  const handleEditApi = (id) => {
    const api = ragApis.find(a => a.id === id);
    if (api) {
      setNewApi({
        name: api.name,
        url: api.url,
        keywords: api.keywords.join(', '),
        description: api.description || '',
        category: api.category || '기타'
      });
      setEditingId(id);
      setIsAddingNew(true);
      setValidationErrors([]);
    }
  };

  // RAG API 수정 저장
  const handleSaveEdit = () => {
    // 유효성 검사
    const validation = validateRagApiConfig(newApi);
    if (!validation.isValid) {
      setValidationErrors(validation.errors);
      return;
    }

    setValidationErrors([]);

    const updatedApis = ragApis.map(api => 
      api.id === editingId 
        ? {
            ...api,
            name: newApi.name,
            url: newApi.url,
            keywords: newApi.keywords.split(',').map(k => k.trim()).filter(k => k),
            description: newApi.description,
            updatedAt: new Date().toISOString()
          }
        : api
    );

    setRagApis(updatedApis);
    saveRagApis(updatedApis);
    
    // 폼 초기화
    setNewApi({ name: '', url: '', keywords: '', description: '', category: '기타' });
    setEditingId(null);
    setIsAddingNew(false);
  };

  // RAG API 삭제
  const handleDeleteApi = (id) => {
    if (window.confirm('정말로 이 RAG API를 삭제하시겠습니까?')) {
      const updatedApis = ragApis.filter(api => api.id !== id);
      setRagApis(updatedApis);
      saveRagApis(updatedApis);
    }
  };

  // 기본 RAG API 설정
  const handleSetDefault = (id) => {
    const updatedApis = ragApis.map(api => ({
      ...api,
      isDefault: api.id === id
    }));
    setRagApis(updatedApis);
    saveRagApis(updatedApis);
  };

  // 폼 취소
  const handleCancel = () => {
    setNewApi({ name: '', url: '', keywords: '', description: '', category: '기타' });
    setEditingId(null);
    setIsAddingNew(false);
    setValidationErrors([]);
  };

  // 입력 필드 변경 시 유효성 검사
  const handleInputChange = (field, value) => {
    setNewApi({...newApi, [field]: value});
    
    // 실시간 유효성 검사
    if (field === 'name' || field === 'url') {
      const tempApi = { ...newApi, [field]: value };
      const validation = validateRagApiConfig(tempApi);
      setValidationErrors(validation.errors);
    }
  };

  return (
    <div className="rag-settings-page">
      <div className="rag-settings-header">
        <h2>RAG API 설정</h2>
        <p>RAG API를 추가하고 관리하여 의도 분류 및 검색 기능을 설정할 수 있습니다.</p>
      </div>

      {/* 새 RAG API 추가 폼 */}
      {isAddingNew && (
        <div className="rag-api-form">
          <h3>{editingId ? 'RAG API 수정' : '새 RAG API 추가'}</h3>
          
          {/* 유효성 검사 오류 표시 */}
          {validationErrors.length > 0 && (
            <div className="validation-errors">
              {validationErrors.map((error, index) => (
                <div key={index} className="error-message">{error}</div>
              ))}
            </div>
          )}
          
          {/* 유효성 검사 오류 표시 */}
          {validationErrors.length > 0 && (
            <div className="validation-errors">
              {validationErrors.map((error, index) => (
                <div key={index} className="error-message">{error}</div>
              ))}
            </div>
          )}

          <div className="form-group">
            <label>API 이름 *</label>
            <input
              type="text"
              value={newApi.name}
              onChange={(e) => handleInputChange('name', e.target.value)}
              placeholder="예: 의료 문서 RAG API"
              className={validationErrors.some(e => e.includes('이름')) ? 'error' : ''}
            />
          </div>
          <div className="form-group">
            <label>API URL *</label>
            <input
              type="url"
              value={newApi.url}
              onChange={(e) => handleInputChange('url', e.target.value)}
              placeholder="예: http://localhost:8000/api/v1/rags/retriever/{rag_id}"
              className={validationErrors.some(e => e.includes('URL')) ? 'error' : ''}
            />
          </div>
          <div className="form-group">
            <label>의도 분류 키워드</label>
            <input
              type="text"
              value={newApi.keywords}
              onChange={(e) => handleInputChange('keywords', e.target.value)}
              placeholder="예: 의료, 진료, 환자, 약물 (쉼표로 구분)"
            />
            <small>이 키워드들을 기반으로 의도 분류가 수행됩니다.</small>
          </div>
          <div className="form-group">
            <label>설명</label>
            <textarea
              value={newApi.description}
              onChange={(e) => handleInputChange('description', e.target.value)}
              placeholder="RAG API에 대한 설명을 입력하세요"
              rows="3"
            />
          </div>
          <div className="form-group">
            <label>카테고리</label>
            <select
              value={newApi.category}
              onChange={(e) => handleInputChange('category', e.target.value)}
            >
              <option value="기타">기타</option>
              <option value="피부과">피부과</option>
              <option value="의료">의료</option>
              <option value="기술">기술</option>
              <option value="교육">교육</option>
              <option value="비즈니스">비즈니스</option>
            </select>
            <small>이 RAG API가 처리할 주제 카테고리를 선택하세요.</small>
          </div>
          <div className="form-actions">
            <button 
              className="btn-primary"
              onClick={editingId ? handleSaveEdit : handleAddApi}
              disabled={validationErrors.length > 0}
            >
              {editingId ? '수정' : '추가'}
            </button>
            <button className="btn-secondary" onClick={handleCancel}>
              취소
            </button>
          </div>
        </div>
      )}

      {/* RAG API 목록 */}
      <div className="rag-apis-section">
        <div className="section-header">
          <h3>등록된 RAG API 목록 ({ragApis.length})</h3>
          <div className="header-actions">
            {!isAddingNew && (
              <button 
                className="btn-primary"
                onClick={() => setIsAddingNew(true)}
              >
                + 새 RAG API 추가
              </button>
            )}
            <button 
              className="btn-secondary"
              onClick={() => {
                console.log('기본 설정으로 리셋 시작');
                localStorage.removeItem('ragApis');
                const defaultApis = initializeDefaultRagApis();
                console.log('리셋된 기본 API:', defaultApis);
                setRagApis(defaultApis);
              }}
              style={{ marginLeft: '10px' }}
            >
              기본 설정으로 리셋
            </button>
          </div>
        </div>

        {ragApis.length === 0 ? (
          <div className="no-apis">
            <p>등록된 RAG API가 없습니다.</p>
            <p>새 RAG API를 추가하여 의도 분류 기능을 설정하세요.</p>
          </div>
        ) : (
          <div className="rag-apis-list">
            {ragApis.map((api) => (
              <div key={api.id} className={`rag-api-item ${api.isDefault ? 'default' : ''}`}>
                <div className="api-info">
                  <div className="api-header">
                    <h4>{api.name}</h4>
                    {api.isDefault && <span className="default-badge">기본</span>}
                  </div>
                  <p className="api-url">{api.url}</p>
                  {api.description && (
                    <p className="api-description">{api.description}</p>
                  )}
                  {api.keywords.length > 0 && (
                    <div className="api-keywords">
                      <strong>키워드:</strong>
                      <div className="keywords-list">
                        {api.keywords.map((keyword, index) => (
                          <span key={index} className="keyword-tag">{keyword}</span>
                        ))}
                      </div>
                    </div>
                  )}
                  {api.category && (
                    <div className="api-category">
                      <strong>카테고리:</strong>
                      <span className="category-tag">{api.category}</span>
                    </div>
                  )}
                  <div className="api-meta">
                    <span>생성: {new Date(api.createdAt).toLocaleDateString()}</span>
                    {api.updatedAt && (
                      <span>수정: {new Date(api.updatedAt).toLocaleDateString()}</span>
                    )}
                  </div>
                </div>
                <div className="api-actions">
                  <button 
                    className="btn-secondary"
                    onClick={() => handleEditApi(api.id)}
                  >
                    수정
                  </button>
                  <button 
                    className="btn-secondary"
                    onClick={() => handleSetDefault(api.id)}
                    disabled={api.isDefault}
                  >
                    기본 설정
                  </button>
                  <button 
                    className="btn-danger"
                    onClick={() => handleDeleteApi(api.id)}
                  >
                    삭제
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export default RagSettingsPage; 