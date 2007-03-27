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

import java.io.IOException;

import org.eclipse.ant.core.AntRunner;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.IPlatform;

/**
 * An IPackager to interface with the Instantiations-contributed installer
 * framework.
 */
public class InstallerPackager implements IPackager {

  private static final String INSTALLER_PLUGIN_ID = "com.instantiations.installer"; //$NON-NLS-1$
  private final IPackagerConfiguration configuration;

  /**
   * TODO mknauer missing doc
   * @param configuration
   */
  public InstallerPackager( final IPackagerConfiguration configuration ) {
    this.configuration = configuration;
  }

  /**
   * Creates the installers. Requires the packager-generated archives to be
   * present as input source.
   */
  public void packApplication() throws IOException, CoreException {
    for( IPlatform platform : this.configuration.getTargetPlatforms() ) {
      AntRunner runner = new AntRunner();
      runner.setBuildFileLocation( getBuildScript( platform ) );
      System.setProperty( "build.root",  //$NON-NLS-1$
                          this.configuration.getTargetFolder().getAbsolutePath() );
      System.setProperty( "product.name", //$NON-NLS-1$
                          "Install-" //$NON-NLS-1$
                              + platform.getTargetFileName( this.configuration ) );
      System.setProperty( "install.tools", //$NON-NLS-1$
                          PluginUtils.getPluginPath( INSTALLER_PLUGIN_ID )
                              + "/" ); //$NON-NLS-1$
      System.setProperty( "install.image", //$NON-NLS-1$
                          this.configuration.getTargetFolder() + "/" //$NON-NLS-1$
                              + platform.getTargetFileName( this.configuration )
                              + platform.getArchiveFormat().getExtension() );
      runner.setExecutionTargets( new String[]{
        getAntTarget( platform )
      } );
      runner.run();
    }
  }

  private String getAntTarget( final IPlatform platform ) {
    String target = null;
    switch( platform.getArchiveFormat() ) {
      case antZip: {
        target = "build_installer_from_zip"; //$NON-NLS-1$
        break;
      }
      case tar: {
        target = "build_installer_from_tar"; //$NON-NLS-1$
        break;
      }
    }
    return target;
  }

  private String getBuildScript( final IPlatform platform ) {
    String folder = this.configuration.getInstallerConfigurationFolder() + "/"; //$NON-NLS-1$
    return folder + platform.getInstallScriptName();
  }
}