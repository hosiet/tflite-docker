#/bin/bash

MY_UID=$(id -u)
MY_GID=$(id -g)

docker run --name c1 -itd --user ${MY_UID}:${MY_GID} -v ~/src/tflite-docker/misc:/host_dir/misc -v ~/src/github/hosiet/tensorflow:/host_dir/tensorflow -v ~/src/tflite-docker/bazel_cache:/host_dir/bazel_cache -v ~/src/tflite-docker/.tf_configure.bazelrc:/host_dir/tensorflow/.tf_configure.bazelrc -tflite-builder:boyuanv1 bash
#docker run --name c1 -itd -v ~/src/tflite-docker/misc:/host_dir/misc -v ~/src/github/hosiet/tensorflow:/host_dir/tensorflow -v ~/src/tflite-docker/bazel_cache:/host_dir/bazel_cache tflite-builder:boyuanv1 bash

docker exec -u root c1 groupadd -g 1000 user
docker exec -u root c1 useradd -m -g 1000 -s /bin/bash user
printf "After entering the environment, execute the following commands to build:\n\n%s\n\n" "cd /host_dir/tensorflow ; bazel --output_user_root=../bazel_cache/cache build -c opt --cxxopt=--std=c++17 --config=android_arm64 --fat_apk_cpu=x86,x86_64,arm64-v8a,armeabi-v7a --define=android_dexmerger_tool=d8_dexmerger --define=android_incremental_dexing_tool=d8_dexbuilder //tensorflow/lite/java:tensorflow-lite //tensorflow/lite/java:tensorflow-lite-gpu //tensorflow/lite/java:tensorflow-lite-api"
#printf "After entering the environment, execute the following commands to build:\n\n%s\n\n" "cd /host_dir/tensorflow ; bazel --output_user_root=../bazel_cache/cache build -c opt --cxxopt=--std=c++17 --config=android_arm64 --fat_apk_cpu=x86,x86_64,arm64-v8a,armeabi-v7a --define=android_dexmerger_tool=d8_dexmerger --define=android_incremental_dexing_tool=d8_dexbuilder //tensorflow/lite/java:tensorflow-lite"

docker exec -it c1 bash