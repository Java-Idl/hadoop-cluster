Hadoop cluster (Docker Compose)

This repository contains a small Hadoop cluster configured to run with Docker Compose for development and testing.

Contents
- docker-compose.yml: Compose setup for NameNode, DataNodes, ResourceManager, NodeManager and helper init services.
- config/: Hadoop configuration files (core-site.xml, yarn-site.xml, hdfs-site.xml, mapred-site.xml).

Requirements
- Docker Desktop (or Docker Engine) with Compose support
- gh (GitHub CLI) configured with an authenticated account
- Windows: run commands shown in PowerShell

Quick start
1. From the project directory:
   docker compose up -d
2. Check services and health:
   docker compose ps

Web UIs (host)
- NameNode: http://localhost:9870
- ResourceManager: http://localhost:8088
- NodeManager: http://localhost:8042

Common CLI (inside container)
- Enter the NameNode container:
   docker exec -it namenode bash
- List HDFS root:
   hdfs dfs -ls /
- Put and read a test file:
   echo "hello" > /tmp/hello.txt
   hdfs dfs -mkdir -p /user/hadoop
   hdfs dfs -put -f /tmp/hello.txt /user/hadoop/
   hdfs dfs -cat /user/hadoop/hello.txt

Notes
- The web UI may show internal container hostnames (for example resourcemanager:8088). Use the localhost ports above from your host, or add host aliases in your OS hosts file for convenience.
- The compose healthchecks probe container-local hostnames; if you change service hostnames, update the healthchecks in docker-compose.yml.

License
MIT
