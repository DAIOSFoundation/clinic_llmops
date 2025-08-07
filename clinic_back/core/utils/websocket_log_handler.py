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
            
        except Exception:
            # WebSocket 전송 실패 시 무시 (로그 시스템이 중단되지 않도록)
            pass 