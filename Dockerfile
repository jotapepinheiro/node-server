FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install Node.js 20
RUN dnf update -y && \
    dnf install -y nodejs npm && \
    dnf clean all

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]