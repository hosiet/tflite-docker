#/bin/bash

MY_UID=$(id -u)
MY_GID=$(id -g)

HOLDER_DIR_PATH="${HOME}/src/tflite-docker/"
TENSORFLOW_DIR_PATH="${HOME}/src/github/hosiet/tensorflow"

docker run --name c1 -itd --user ${MY_UID}:${MY_GID} -v ${HOLDER_DIR_PATH}/misc:/host_dir/misc -v "${TENSORFLOW_DIR_PATH}":/host_dir/tensorflow -v "${HOLDER_DIR_PATH}"/bazel_cache:/host_dir/bazel_cache -v "${HOLDER_DIR_PATH}"/.tf_configure.bazelrc:/host_dir/tensorflow/.tf_configure.bazelrc tflite-builder:boyuanv1 bash

docker exec -u root c1 groupadd -g 1000 user
docker exec -u root c1 useradd -m -g 1000 -s /bin/bash user
printf "After entering the environment, execute the following commands to build:\n\n%s\n\n" \
        "cd /host_dir/tensorflow ; bazel --output_user_root=../bazel_cache/cache build -c opt --cxxopt=--std=c++17 --config=android_arm64 --fat_apk_cpu=x86,x86_64,arm64-v8a,armeabi-v7a --define=android_dexmerger_tool=d8_dexmerger --define=android_incremental_dexing_tool=d8_dexbuilder //tensorflow/lite/java:tensorflow-lite //tensorflow/lite/java:tensorflow-lite-gpu //tensorflow/lite/java:tensorflow-lite-api //tensorflow/lite/java:tensorflow-lite-gpu-api"

docker exec -it c1 bash
