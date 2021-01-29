# 基础镜像，本次构建时对应版本为 node:14.15.4-alpine3.11
FROM node:lts-alpine 
# 暴露容器端口
EXPOSE 7001
# 更换为阿里更新源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# 设置时区
RUN apk --update add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata
# 设置工作目录
WORKDIR /app
# 配置faas监控
COPY of-watchdog-0.8.1 /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

ENV cgi_headers="true"
ENV fprocess="npm run faas-start"
ENV mode="http"
ENV upstream_url="http://127.0.0.1:7001"


HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1


CMD ["fwatchdog"]