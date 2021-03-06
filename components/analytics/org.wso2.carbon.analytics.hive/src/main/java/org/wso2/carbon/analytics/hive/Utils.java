/**
 * Copyright (c) 2009, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.wso2.carbon.analytics.hive;

import org.wso2.carbon.utils.CarbonUtils;

public class Utils {

    public static final String CARBON_CONFIG_PORT_OFFSET_NODE = "Ports.Offset";

    public static final int CARBON_DEFAULT_PORT_OFFSET = 0;

    public static final int HIVE_SERVER_DEFAULT_PORT = 21000;

    public static boolean connectRSS = false;

    public static int getPortOffset() {
        return CarbonUtils.getPortFromServerConfig(
                CARBON_CONFIG_PORT_OFFSET_NODE)+1;
    }

    public static boolean canConnectToRSS(){
      return Utils.connectRSS;
    }

    public static void setConnectRSS(boolean connectRSS){
      Utils.connectRSS = connectRSS;
    }

}
