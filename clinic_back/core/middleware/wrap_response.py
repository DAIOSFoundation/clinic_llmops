from rest_framework.response import Response


class WrapResponseMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)

        if isinstance(response, Response) and 200 <= response.status_code < 300:
            if (
                isinstance(response.data, dict)
                and "error" not in response.data
                and "data" not in response.data
            ):
                response.data = {"data": response.data}
            else:
                response.data = {"data": response.data}

            current_content_type = response.headers.get("Content-Type")
            if current_content_type and "application/json" in current_content_type:
                if "charset" not in current_content_type:
                    response.headers["Content-Type"] = (
                        f"{current_content_type}; charset=utf-8"
                    )
            else:
                response.headers["Content-Type"] = "application/json; charset=utf-8"

            if getattr(response, "_is_rendered", False):
                response._is_rendered = False
                response.render()
        return response
