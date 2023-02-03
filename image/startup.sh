#!/bin/bash
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>.

source ~/.bashrc
echo "===================================================================="
if [ ! -d /tmp/uyuni-docs ]; then
echo " Git repository: ${GITREPO}"
echo " Git reference: ${GITREF}"
fi
echo " Product: ${PRODUCT}"
echo " Make command: ${COMMAND}"
echo "===================================================================="

cd ~
rm -rf uyuni-docs

if [ -d /tmp/uyuni-docs ]; then
  cp -r /tmp/uyuni-docs ~
  rm -rf /tmp/uyuni-docs/build
else 
  git clone -b ${GITREF} --depth 1 ${GITREPO} uyuni-docs
fi

cd uyuni-docs
make configure-${PRODUCT}
make ${COMMAND}

if [ -d /tmp/uyuni-docs ]; then
  cp -r ~/uyuni-docs/build /tmp/uyuni-docs
fi

if [ "${SERVE}" == "1" ]; then
  echo "INFO: Serving the doc on port 8000 on the container"
  echo "INFO: To access the doc from outside the container, check its mapping"
  echo "INFO: Most likely you can access http://localhost:8000/build/en to check"
  echo "      the rendered documentation, or http://localhost:8000 to inspect"
  echo "      everything"
  echo "INFO: Remember to use CTRL+C to stop the container, when you are done"
  python3 -m http.server
fi
