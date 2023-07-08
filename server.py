from typing import List, Literal
from litestar import Litestar
from litestar import Controller, post
from pydantic import BaseModel
import subprocess


class Message(BaseModel):
    role: Literal["system"] | Literal["user"] | Literal["assistant"]
    content: str


class Request(BaseModel):
    model: str
    messages: List[Message]


def create_prompt(messages: List[Message]) -> str:
    prompt = ""
    for m in messages:
        if m.role == "user":
            prompt += m.content + "\n"
        elif m.role == "assistant":
            prompt += "### Response:" + "\n" + m.content + "\n"
        elif m.role == "system":
            prompt += "### System:" + "\n" + m.content + "\n"
        prompt += "### Response:\n"
    return prompt


class FalconController(Controller):
    path = "/v1/chat/completions"

    @post()
    async def run(self, data: Request) -> str:
        print(data.messages)
        prompt = create_prompt(data.messages)
        result = subprocess.run(
            "/usr/local/bin/falcon_main",
            "-t",
            "11",
            "-n",
            "32",
            "-m",
            "/app/models/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin",
            "-p",
            prompt,
            stdout=subprocess.PIPE,
        )
        return result


app = Litestar(route_handlers=[FalconController])
