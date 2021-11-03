FROM sitespeedio/node:ubuntu-18.04-nodejs10.15.3
ARG VAULT
RUN apt update && apt install -y make git g++ python nano htop mc
COPY . /home/plasma-contracts

WORKDIR /home/plasma-contracts/MultiSigWallet
RUN if [ "$VAULT" = "true" ]; then \
  rm -Rf ./node_modules && \
  rm -Rf ./build && \
  npm install && \
  npx truffle version && \
  npx truffle compile; \
fi

WORKDIR /home/plasma-contracts/plasma_framework
RUN rm -Rf ./node_modules && \
rm -Rf ./build && \
npm install && \
npx truffle version && \
npx truffle compile
 
#CMD  npx truffle migrate --network ganachewin
