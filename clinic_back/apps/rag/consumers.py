import json
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync


class LogConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()
        await self.channel_layer.group_add("logs", self.channel_name)

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard("logs", self.channel_name)

    async def receive(self, text_data):
        # 클라이언트로부터 메시지를 받았을 때의 처리
        pass

    async def log_message(self, event):
        # 로그 메시지를 클라이언트에게 전송
        await self.send(text_data=json.dumps({
            'type': 'log',
            'message': event['message'],
            'level': event['level'],
            'timestamp': event['timestamp']
        }))


# 동기 함수로 로그를 전송하는 헬퍼 함수
def send_log_to_clients(message, level="INFO"):
    try:
        from datetime import datetime
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            "logs",
            {
                "type": "log_message",
                "message": message,
                "level": level,
                "timestamp": datetime.now().isoformat()
            }
        )
    except Exception as e:
        # WebSocket 전송 실패 시 로그 출력 (디버깅용)
        print(f"WebSocket 로그 전송 실패: {e}")
        pass 