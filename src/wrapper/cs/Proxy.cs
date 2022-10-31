/*
 * Copyright (c) 2004-2019 Lightstreamer s.r.l., Via Campanini, 6 - 20124 Milano, Italy.
 * All rights reserved.
 * www.lightstreamer.com
 *
 * This software is the confidential and proprietary information of
 * Lightstreamer s.r.l.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered
 * into with Lightstreamer s.r.l.
 */

namespace com.lightstreamer.client
{
    /// <summary>
    /// Simple class representing a Proxy configuration. <BR>
    /// 
    /// An instance of this class can be used through <seealso cref="ConnectionOptions#setProxy(Proxy)"/> to
    /// instruct a LightstreamerClient to connect to the Lightstreamer Server passing through a proxy.
    /// </summary>
    public class Proxy
    {
       

        public Proxy(Proxy proxy)
        {

        }

        /// <summary>
        /// This constructor will call <seealso cref="#Proxy(String, String, int, String, String)"/>
        /// specifying null user and null password. </summary>
        /// <param name="type"> the proxy type </param>
        /// <param name="host"> the proxy host </param>
        /// <param name="port"> the proxy port </param>
        public Proxy(string type, string host, int port)
        {

        }

        /// <summary>
        /// This constructor will call <seealso cref="#Proxy(String, String, int, String, String)"/>
        /// specifying a null null password. </summary>
        /// <param name="type"> the proxy type </param>
        /// <param name="host"> the proxy host </param>
        /// <param name="port"> the proxy port </param>
        /// <param name="user"> the user name to be used to validate against the proxy </param>
        public Proxy(string type, string host, int port, string user)
        {

        }

        /// <summary>
        /// Creates a Proxy instance containing all the informations required by the <seealso cref="LightstreamerClient"/>
        /// to connect to a Lightstreamer server passing through a proxy. <BR>
        /// Once created the Proxy instance has to be passed to the <seealso cref="LightstreamerClient#connectionOptions"/>
        /// instance using the <seealso cref="ConnectionOptions#setProxy(Proxy)"/> method.
        /// 
        /// BEGIN_ANDROID_DOC_ONLY
        /// <BR><BR>
        /// Note: user and password are ignored. If authentication is required by the proxy in use
        /// it is necessary to replace the default java <seealso cref="java.net.Authenticator"/> with a custom one containing 
        /// the necessary logic to authenticate the user against the proxy.  
        /// END_ANDROID_DOC_ONLY
        /// </summary>
        /// <param name="type"> the proxy type </param>
        /// <param name="host"> the proxy host </param>
        /// <param name="port"> the proxy port </param>
        /// <param name="user"> the user name to be used to validate against the proxy </param>
        /// <param name="password"> the password to be used to validate against the proxy </param>
        public Proxy(string type, string host, int port, string user, string password)
        {

        }

        public override string ToString()
        {

        }

        public override bool Equals(object obj)
        {

        }

        public override int GetHashCode()
        {
          
        }
    }
}