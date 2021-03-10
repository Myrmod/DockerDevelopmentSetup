# specify the node base image with your desired version node:<version>
FROM node:14 as base

# ARG SSH_PRIVATE_KEY
# ARG SSH_PUBLIC_KEY
# ARG SSH_CONFIG

RUN apt-get update && apt-get install -y openssh-client

RUN mkdir /root/.ssh && \
   ln -s /run/secrets/user_private_ssh_key /root/.ssh/id_rsa && \
   ln -s /run/secrets/user_public_ssh_key /root/.ssh/id_rsa.pub && \
   ln -s /run/secrets/ssh_config /root/.ssh/config
# cat "${SSH_PRIVATE_KEY}" >> /root/.ssh/id_rsa && \
# cat "${SSH_PUBLIC_KEY}" >> /root/.ssh/id_rsa.pub && \
# cat "${SSH_CONFIG}" >> /root/.ssh/config

FROM base
# COPY ./config ~/.ssh/config
# RUN chown -R node:node /home/node
# RUN cat ~/.ssh/config >> /etc/ssh/ssh_config
# RUN whoami
# RUN ssh -v git@git.sb12.de
# RUN git ls-remote --tags --heads ssh://git@git.sb12.de/b12touch/player/web/sspcontentext.git
COPY --from=base /root/.ssh ~/.ssh

WORKDIR /home/root/app
COPY . /home/root/app

RUN yarn install --verbose
COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "yarn", "dev" ]
