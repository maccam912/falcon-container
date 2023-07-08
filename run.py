import uvicorn
import server

if __name__ == "__main__":
    uvicorn.run(server.app, log_level="trace")
