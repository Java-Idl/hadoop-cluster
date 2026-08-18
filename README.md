# Hadoop cluster (Docker Compose)

A small Hadoop cluster configured to run with Docker Compose for development and testing.

## Contents
- `docker-compose.yml` — Compose setup for NameNode, DataNodes, ResourceManager, NodeManager, and helper init services.
- `config/` — Hadoop configuration files (`core-site.xml`, `yarn-site.xml`, `hdfs-site.xml`, `mapred-site.xml`).
- `py-scripts/` — Python mapper and reducer scripts for Hadoop Streaming.

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

## Run Hadoop Streaming with Python scripts
The repository already includes the scripts in `py-scripts/mapper.py` and `py-scripts/reducer.py`.

1. Copy scripts from host into the NameNode container:

```bash
docker cp py-scripts/mapper.py namenode:/tmp/mapper.py
docker cp py-scripts/reducer.py namenode:/tmp/reducer.py
```

2. Open a shell in the NameNode container and make them executable:

```bash
docker exec -it namenode bash
chmod +x /tmp/mapper.py /tmp/reducer.py
```

3. Remove old output and run the streaming job:

```bash
hdfs dfs -rm -r -f /user/hadoop/output_py

hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files /tmp/mapper.py,/tmp/reducer.py \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py" \
  -input /user/hadoop/input \
  -output /user/hadoop/output_py
```

4. View output in CLI:

```bash
hdfs dfs -cat /user/hadoop/output_py/part-00000
```

5. View output in UI:
- Open NameNode UI: `http://localhost:9870`
- Go to **Utilities** → **Browse the file system**
- Set path to: `/user/hadoop/output_py`

## Notes
- The web UI may show internal container hostnames (for example `resourcemanager:8088`). Use the localhost ports above from your host, or add host aliases in your OS hosts file if you want the UI links to resolve.
- The compose healthchecks probe container-local hostnames; if you change service hostnames, update the healthchecks in `docker-compose.yml`.