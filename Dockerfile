# syntax=docker/dockerfile:1
FROM python:3.9-bullseye

RUN pip install --no-cache-dir --upgrade pip wheel

WORKDIR /src

# Install debian packages

RUN set -x ; \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libpq-dev libldap2-dev libsasl2-dev postgresql-client nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Install wkhtml

ARG WKHTMLTOPDF_URL=https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb

RUN curl -sSL $WKHTMLTOPDF_URL -o /tmp/wkhtml.deb \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends --fix-missing -qq /tmp/wkhtml.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm /tmp/wkhtml.deb

RUN npm install --global es-check

RUN curl -sSL https://raw.githubusercontent.com/odoo/odoo/master/requirements.txt -o /tmp/odoo-requirements.txt
RUN pip install --no-cache-dir -r /tmp/odoo-requirements.txt inotify websocket-client debugpy

# Install Google Chrome

#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_90.0.4430.93-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_91.0.4472.77-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_92.0.4515.107-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_93.0.4577.63-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_94.0.4606.61-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_95.0.4638.54-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_96.0.4664.45-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_97.0.4692.71-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_98.0.4758.80-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_99.0.4844.51-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_100.0.4896.60-1_amd64.deb
ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_101.0.4951.64-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_102.0.5005.61-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_103.0.5060.53-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_103.0.5060.134-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_104.0.5112.101-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_105.0.5195.102-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_106.0.5249.103-1_amd64.deb
#ARG CHROME_URL=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

RUN curl -sSL $CHROME_URL -o /tmp/chrome.deb \
    && apt-get update \
    && apt-get -y install --no-install-recommends /tmp/chrome.deb \
    && rm /tmp/chrome.deb

# Run Odoo

EXPOSE 8069
EXPOSE 5678

VOLUME ["/var/lib/odoo", "/src"]

ENV PGHOST=
ENV PGUSER=
ENV PGPASSWORD=

ENTRYPOINT [ "python", "-m", "debugpy", "--listen", "0.0.0.0:5678", "odoo/odoo-bin", "--data-dir", "/var/lib/odoo", "--dev", "xml,qweb,reload"]

