from litestar import Litestar
from litestar import Controller, get


class FalconController(Controller):
    path = "/"
    @get()
    async def run(self, query: str) -> str:
        return "Hello World!"



app = Litestar(route_handlers=[FalconController])