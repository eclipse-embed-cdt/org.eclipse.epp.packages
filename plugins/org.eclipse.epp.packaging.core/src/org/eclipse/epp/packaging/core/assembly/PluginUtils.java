/*******************************************************************************
 * Copyright (c) 2007 Innoopract Informationssysteme GmbH
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Innoopract - initial API and implementation
 *******************************************************************************/
package org.eclipse.epp.packaging.core.assembly;

import java.io.File;
import java.io.IOException;

import org.eclipse.core.runtime.Platform;
import org.eclipse.osgi.service.datalocation.Location;

/**
 * Utility class for Plugin-related tasks.
 */
public class PluginUtils {

  /** Locates the given plugin in the install location. 
   * 
   * TODO mknauer missing doc
   * @param pluginId 
   * @return plugin path
   * @throws IOException 
   */
  // This could be done via SiteManager and featurereferences, if the
  // application was feature-based, not plugin-based.
  public static String getPluginPath( final String pluginId ) throws IOException {
    Location installLocation = Platform.getInstallLocation();
    String locationFile = installLocation.getURL().getFile();
    File file = new File( locationFile, "plugins" ); //$NON-NLS-1$
    String result = null;
    for( File pluginFile : file.listFiles() ) {
      if( pluginFile.getName().startsWith( pluginId ) ) {
        result = pluginFile.getCanonicalPath();
      }
    }
    if( result == null ) {
      throw new IllegalStateException( "Required plug-in "  //$NON-NLS-1$
                                       + pluginId 
                                       + " not found in folder "  //$NON-NLS-1$
                                       + locationFile 
                                       + "plugins." ); //$NON-NLS-1$
    }
    return result;
  }
}