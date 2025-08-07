import logging
from apps.rag.consumers import send_log_to_clients


class WebSocketLogHandler(logging.Handler):
    def emit(self, record):
        try:
            # 로그 레벨에 따른 이모지 매핑
            level_emojis = {
                'DEBUG': '🔍',
                'INFO': 'ℹ️',
                'WARNING': '⚠️',
                'ERROR': '❌',
                'CRITICAL': '🚨'
            }
            
            emoji = level_emojis.get(record.levelname, 'ℹ️')
            
            # 로그 메시지 포맷팅
            log_message = f"{emoji} {record.getMessage()}"
            
            # WebSocket을 통해 클라이언트에게 전송
            send_log_to_clients(log_message, record.levelname)
            
        except Exception as e:
            # WebSocket 전송 실패 시 디버깅 정보 출력
            print(f"WebSocket 로그 핸들러 오류: {e}")
            pass 