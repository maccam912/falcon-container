import asyncio
from litestar.response import Stream
from typing import List, Literal
from litestar import Litestar
from litestar import Controller, post
from pydantic import BaseModel
import subprocess
import logging

logger = logging.getLogger(__name__)


class Message(BaseModel):
    role: Literal["system", "user", "assistant"]
    content: str


class Request(BaseModel):
    model: str
    messages: List[Message]


class Usage(BaseModel):
    prompt_tokens: int
    completion_tokens: int
    total_tokens: int


class Choice(BaseModel):
    index: int
    message: Message
    finish_reason: Literal["length", "stop", "restart"]


class Response(BaseModel):
    id: str
    object: str
    created: int
    choices: List[Choice]
    usage: Usage


def create_prompt(messages: List[Message]) -> str:
    prompt = ""
    for m in messages:
        if m.role == "user":
            prompt += "### User:" + "\n" + m.content + "\n"
        elif m.role == "assistant":
            prompt += "### Response:" + "\n" + m.content + "\n"
        elif m.role == "system":
            prompt += "### System:" + "\n" + m.content + "\n"
    prompt += "### Response:\n"
    return prompt


def create_response(result: str) -> Response:
    response = Response(
        id="",
        object="",
        created=0,
        choices=[
            Choice(
                index=0,
                message=Message(role="assistant", content=result),
                finish_reason="length",
            )
        ],
        usage=Usage(prompt_tokens=0, completion_tokens=0, total_tokens=0),
    )
    return response


async def stream_subprocess_stdout(cmd: List[str]):
    # Create subprocess
    process = await asyncio.create_subprocess_exec(*cmd, stdout=subprocess.PIPE)

    # Create async generator
    while True:
        if process.returncode is not None:
            break  # subprocess has finished

        line = await process.stdout.read(1000)  # read up to 1000 bytes
        if line:
            logger.info(f"Got line: {line}")
            yield line

        await asyncio.sleep(0.5)  # wait for half a second

    # Wait for the subprocess to finish
    await process.wait()


class FalconController(Controller):
    path = "/v1/chat/completions"

    @post()
    async def run(self, data: Request) -> Stream:
        logger.info("In run")
        logger.info("Got request")
        prompt = create_prompt(data.messages)
        logger.info("created prompt")
        cmd = [
            "/usr/local/bin/falcon_main",
            "-t",
            "11",
            "-c",
            "2048",
            "-b",
            "64",
            "--prompt-cache",
            "/app/models/cache",
            "--prompt-cache-all",
            "-m",
            "/app/models/wizardlm-7b-uncensored.ggccv1.q8_0.bin",
            # "/app/models/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin",
            "-p",
            prompt,
        ]

        return Stream(stream_subprocess_stdout(cmd))


app = Litestar(route_handlers=[FalconController])
