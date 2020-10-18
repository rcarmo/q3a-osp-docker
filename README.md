# Quake 3 OSP dedicated server Docker image

This is a (WIP) fork of [`smikhalevski/q3a-osp-docker`](https://github.com/smikhalevski/q3a-osp-docker) to build a smaller image (that doesn't ship with ID Software's PAK files and grabs them off a volume).

I'm also in the process of tweaking the build process so that you can get it going on an entirely blank machine.

---

## Old README

Run on localhost:

```bash
npm run docker-build
SLACK_WEB_HOOK=<your_slack_web_hook_url> npm run docker-restart
```

Publish build:

```bash
npm run docker-publish
```

Force-stop all containers, install and start q3a container:

```bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

docker pull q3a
docker run -p 27960:27960/udp -p 27960:27960/tcp -e SLACK_WEB_HOOK=<your_slack_web_hook_url> local/q3a
```
