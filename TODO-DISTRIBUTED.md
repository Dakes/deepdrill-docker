# TODO: Distributed Rendering Implementation

## Phase 1: Preparation & Setup
- [ ] Research and select communication protocol (e.g., FastAPI, gRPC, or simple TCP).
- [ ] Create a dedicated development branch (`feature/distributed`).
- [ ] Set up testing environment with at least two Docker containers (one server, one client).

## Phase 2: Server Implementation
- [ ] Task Generation: Develop a parser for `DeepDrill` project configurations to create a task list of frame IDs.
- [ ] Task Dispatcher: Implement a basic HTTP endpoint to serve next-available tasks to clients.
- [ ] Result Collector: Add an endpoint for clients to upload completed frames (`.png`).
- [ ] Video Assembly: Automate `ffmpeg` to stitch completed frames once all tasks are finished.

## Phase 3: Client Implementation
- [ ] Worker Loop: Implement a loop that polls the server for a task ID.
- [ ] Frame Rendering: Call `deepdrill-cmd` with parameters received from the server.
- [ ] Frame Upload: Send the resulting frame back to the server and report success.

## Phase 4: Network & Discovery
- [ ] UDP Auto-Discovery: Implement a simple UDP beacon/listener for clients to find the server automatically on the same network.
- [ ] Manual Configuration: Support `SERVER_IP` environment variable as a fallback.

## Phase 5: Testing & Optimization
- [ ] Multi-arch Testing: Verify performance and correctness on both x86 and ARM (e.g., Raspberry Pi or Apple Silicon).
- [ ] Error Handling: Ensure tasks are re-queued if a client disconnects mid-render.
- [ ] Performance Logging: Track render times per client and per frame.

## Phase 6: User Abstraction
- [ ] CLI Interface: Create a simplified command (e.g., `deepdrill-distribute render project.ini`) to hide internal complexity.
- [ ] Documentation: Update `README.md` with setup and usage instructions.

---
*Created by Konoha (AI Agent)*
