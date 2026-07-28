RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

# amazonlinux:2 requires !python3 so we aren't really testing it
IMAGES=${1}
for image in ${IMAGES:=ubuntu:jammy ubuntu:noble amazonlinux:2023 rockylinux:8 rockylinux:9}; do
  echo ">> ${BLUE}INFO${RESET} Testing ${image}" | tee -a molecule/test.log
  tag="${image#*:}"
  image="${image%%:*}" tag=${tag} pipenv run molecule test >> molecule/test.log 2>&1
  if [ "$?" -ne 0 ]; then
    echo "== ${RED}FAILURE${RESET} did not complete successfully" | tee -a molecule/test.log
    exit 1
  else
    echo "== ${GREEN}SUCCESS${RESET}"
  fi
done
