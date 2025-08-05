from core.constants.error_code import get_error_message


class AppException(Exception):
    def __init__(self, code, status_code=400):
        self.code = code
        self.message = get_error_message(code)
        self.status_code = status_code
        super().__init__(self.message)
