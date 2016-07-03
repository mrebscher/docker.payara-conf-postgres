FROM mrebscher/payara-base
MAINTAINER mrebscher

# set credentials to admin/admin
RUN echo -e 'AS_ADMIN_PASSWORD=\n\
AS_ADMIN_NEWPASSWORD=admin\n\
EOF\n'\
>> /opt/tmpfile

RUN echo -e 'AS_ADMIN_PASSWORD=admin\n\
EOF\n'\
>> /opt/pwdfile

ADD lib/* ${PAYARA_HOME}/domains/${DOMAIN_NAME}/lib/

RUN asadmin start-domain ${DOMAIN_NAME} && \
    asadmin delete-jvm-options -Xmx512m  && \
    asadmin create-jvm-options -Xms2G  && \
    asadmin create-jvm-options -Xmx2G  && \
    asadmin set server.thread-pools.thread-pool.http-thread-pool.max-thread-pool-size=16 && \
    asadmin create-jdbc-connection-pool \
      --datasourceclassname org.postgresql.ds.PGPoolingDataSource \
      --restype javax.sql.DataSource \
      --property user=appservertest:password=appservertest:DatabaseName=appservertestdb:ServerName=postgres:port=5432 \
      postgres_pool && \
    asadmin set resources.jdbc-connection-pool.postgres-pool.steady-pool-size=10 && \
    asadmin set resources.jdbc-connection-pool.postgres-pool.max-pool-size=200 && \
    asadmin create-jdbc-resource --connectionpoolid postgres_pool jdbc/appservertest && \
    asadmin --user admin --passwordfile=/opt/tmpfile change-admin-password && \
    asadmin --user admin --passwordfile=/opt/pwdfile enable-secure-admin && \
    asadmin stop-domain ${DOMAIN_NAME} && \
    rm /opt/tmpfile
