FROM python:3.8-alpine

# Install base utilities
RUN set -eux; \
    apk --no-cache add openssl curl ca-certificates bash jq groff less; \
    pip --no-cache-dir install awscli deepmerge

# Download the Amazon blessed utilities as per:
# https://docs.aws.amazon.com/eks/latest/userguide/configure-kubectl.html
ADD https://amazon-eks.s3-us-west-2.amazonaws.com/1.16.13/2020-08-04/bin/linux/amd64/kubectl /usr/bin/kubectl
ADD https://amazon-eks.s3-us-west-2.amazonaws.com/1.16.13/2020-08-04/bin/linux/amd64/aws-iam-authenticator /usr/bin/aws-iam-authenticator
RUN chmod +x /usr/bin/kubectl /usr/bin/aws-iam-authenticator

ARG HELM_VERSION="v3.3.1"

RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh \
  && chmod +x ./get_helm.sh \
  && ./get_helm.sh -v $HELM_VERSION \
  && helm -h

# Install the Drone plugin scripts
COPY update.sh /bin/
COPY connect-eks.sh /bin/

ENTRYPOINT ["/bin/bash"]
CMD ["/bin/update.sh"]