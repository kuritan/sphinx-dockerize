#
# build stage
#
FROM python:alpine as build-stage

WORKDIR /root
COPY ./entrypoint.sh /root/entrypoint.sh
RUN apk add build-base

RUN pip install --upgrade pip \
  && pip install sphinx sphinx-autobuild \
  && pip freeze > requirements.txt

#
# running stage
#
FROM python:alpine
COPY --from=build-stage /root/.cache/pip /root/.cache/pip
COPY --from=build-stage /root/requirements.txt /root/requirements.txt
COPY --from=build-stage /root/entrypoint.sh /root/entrypoint.sh

RUN pip install --upgrade pip \
  && pip install -r /root/requirements.txt

WORKDIR /root
ENTRYPOINT ["sh", "/root/entrypoint.sh"]