# Hadoop cluster (Docker Compose)

A small Hadoop cluster configured to run with Docker Compose for development and testing.

## Contents
- `docker-compose.yml` — Compose setup for NameNode, DataNodes, ResourceManager, NodeManager, and helper init services.
- `config/` — Hadoop configuration files (`core-site.xml`, `yarn-site.xml`, `hdfs-site.xml`, `mapred-site.xml`).

## Requirements
- Docker Engine or Docker Desktop with Compose support

## Quick start
From the project directory:

```bash
docker compose up -d
```

Check services and health:

```bash
docker compose ps
```

## Web UIs (host)
- NameNode: http://localhost:9870
- ResourceManager: http://localhost:8088
- NodeManager: http://localhost:8042

## Common CLI (inside container)
Enter the NameNode container and run HDFS commands:

```bash
docker exec -it namenode bash
# list HDFS root
hdfs dfs -ls /
# put and read a test file
echo "hello" > /tmp/hello.txt
hdfs dfs -mkdir -p /user/hadoop
hdfs dfs -put -f /tmp/hello.txt /user/hadoop/
hdfs dfs -cat /user/hadoop/hello.txt
```

## Notes
- The web UI may show internal container hostnames (for example `resourcemanager:8088`). Use the localhost ports above from your host, or add host aliases in your OS hosts file if you want the UI links to resolve.
- The compose healthchecks probe container-local hostnames; if you change service hostnames, update the healthchecks in `docker-compose.yml`.
