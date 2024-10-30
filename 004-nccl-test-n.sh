#!/bin/bash
source /etc/profile

readonly PROGPID=$$
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

#install tools
pip install -U huggingface_hub nvitop

nccldir=${PROGDIR}/nccl/build
cudadir=/usr/local/cuda

if [[ -d ${cudadir} ]]; then
    echo "当前cudadir设置在：${cudadir}"
else
    echo "${cudadir}: NOT FOUND!"
fi

procnum=$(nproc)
tool=${PROGDIR}/nccl-tests/build/all_reduce_perf



function run_bandwidth_test() {
    cd ${PROGDIR}

    rm -fr cuda-samples
    wget -O cuda-samples.tar.gz https://cos-ops.ppio.cloud/IaaS/gpu-test/cuda-samples.tar.gz && tar zxf cuda-samples.tar.gz

    cd ${PROGDIR}/cuda-samples/Samples/5_Domain_Specific/p2pBandwidthLatencyTest
    make
    ./p2pBandwidthLatencyTest |tee ${PROGDIR}/p2pBandwidthLatencyTest.log
}

run_bandwidth_test