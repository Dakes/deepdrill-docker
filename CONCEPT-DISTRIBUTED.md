# Concept: Distributed Rendering for DeepDrill-Docker

## Overview
DeepDrill-Docker aims to distribute the computational load of rendering high-resolution fractal videos across multiple nodes (x86 and ARM). The system will follow a **Server-Client architecture** where a central server manages work distribution and final assembly, while clients perform the heavy lifting of individual frame calculations.

## Architecture

### 1. Server Component
- **Work Package Generator**: Parses the master `DeepMake` / `DeepDrill` project and generates individual `Makefile` tasks or command-line jobs per frame.
- **Task Dispatcher**: Tracks available clients and assigns pending frame tasks.
- **Result Collector**: Receives rendered frames (e.g., `.png` or raw data) from clients and stores them locally.
- **Video Assembler**: Uses `ffmpeg` to stitch collected frames into the final video output once all tasks are complete.
- **Discovery Service**: 
  - **Auto-Discovery**: Listens for client "heartbeats" via UDP broadcast/multicast within the same network.
  - **Manual Configuration**: Allows manual IP entry for fixed infrastructure.

### 2. Client Component
- **Registration**: Announces presence to the server upon startup.
- **Worker Process**: Pulls tasks from the server, executes `deepdrill-cmd` for the assigned frame, and sends the resulting image back.
- **Resource Management**: Reports CPU core availability and current load to ensure efficient task allocation.

## Implementation Details
- **Docker Image**: A single multi-arch image (supporting `linux/amd64` and `linux/arm64`) that can be configured via environment variables (e.g., `ROLE=server` or `ROLE=client`).
- **Communication Protocol**:
  - **Tasking**: Simple REST API or gRPC for task pull/push.
  - **Discovery**: UDP broadcast for simplicity in "same-network only" environments.
- **Resilience**: The server should re-queue tasks if a client disconnects or fails.

## Software Engineering Paradigms
- **Separation of Concerns**: Clear abstraction between task generation, execution, and assembly.
- **Extensibility**: Modular design to support different rendering backends if needed in the future.
- **Portability**: Leveraging Docker ensures consistent environments across diverse hardware.

---
*Created by Konoha (AI Agent)*
