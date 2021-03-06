FROM python:3.6

ENV AIRFLOW_GPL_UNIDECODE=yes
ENV CONFIG /root/.config/gcloud
ENV PATH /root/google-cloud-sdk/bin:$PATH
ENV AIRFLOW_HOME /airflow
ENV AIRFLOW_CONFIG $AIRFLOW_HOME/airflow.cfg
ENV AIRFLOW_USER airflow
#---set your environment
ENV GCPKEY=
ENV GCPSERVICEACCOUNT=
ENV GCPPROJECT=
ENV DAG_REPOSITORY=
ENV AIRFLOW_LOGIN_USER=
ENV AIRFLOW_LOGIN_PASS=
ENV AIRFLOW_FIRSTNAME= 
ENV AIRFLOW_LASTNAME= 
ENV AIRFLOW_EMAIL=
#---

RUN apt update \
    && apt-get -y install \
                  sudo \
                  lhasa \
                  vim \
                  curl \
                  nmap \
                  netcat\
    && pip install \
                  redis \
                  celery \
                  psycopg2 \
                  apache-airflow \
                  apache-airflow[postgres] \
                  apache-airflow[celery] \
                  apache-airflow[gcp_api] \
                  flask_bcrypt \
                  google-api-python-client \
                  pandas_gbq\
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} ${AIRFLOW_USER} \
    && curl https://sdk.cloud.google.com | bash    

ADD config/airflow.cfg ${AIRFLOW_HOME}
ADD keyfile/${GCPKEY} ${CONFIG}/${GCPKEY}
ADD script/entrypoint.sh ${AIRFLOW_HOME}

WORKDIR ${AIRFLOW_HOME}

RUN chmod -R 755 ${AIRFLOW_HOME}
RUN chown -R ${AIRFLOW_USER}: ${AIRFLOW_HOME}
RUN chown -R ${AIRFLOW_USER}: /root
RUN echo "%${AIRFLOW_USER} ALL=NOPASSWD: ALL" >> /etc/sudoers

USER ${AIRFLOW_USER}

ENTRYPOINT ["./entrypoint.sh"]
