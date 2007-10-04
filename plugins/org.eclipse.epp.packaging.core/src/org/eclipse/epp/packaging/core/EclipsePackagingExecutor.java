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
package org.eclipse.epp.packaging.core;

import java.io.IOException;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.epp.packaging.core.assembly.EclipsePackager;
import org.eclipse.epp.packaging.core.assembly.IPackager;
import org.eclipse.epp.packaging.core.assembly.PackageMover;
import org.eclipse.epp.packaging.core.configuration.ICommands;
import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.Task;
import org.eclipse.epp.packaging.core.download.ExtensionSiteManager;
import org.eclipse.epp.packaging.core.download.IUpdateSiteManager;
import org.eclipse.epp.packaging.core.download.UpdateSiteManager;
import org.eclipse.epp.packaging.core.logging.MessageLogger;

/**
 * The main class, independent from the creation of the configuration and less
 * dependent on the application/platform runnable
 */
public class EclipsePackagingExecutor {

  private final ICommands commands;
  private final IPackagerConfiguration configuration;

  public EclipsePackagingExecutor( final ICommands commands,
                                   final IPackagerConfiguration configuration )
  {
    this.commands = commands;
    this.configuration = configuration;
  }

  /** 
   * Run the packaging process 
   */
  public void execute() throws CoreException, IOException {
    MessageLogger logger = MessageLogger.getInstance();
    logger.log( "Application.FeatureCount", //$NON-NLS-1$
                Integer.valueOf( this.configuration.getRequiredFeatures().length ) );
    boolean doCheckOrInstall =    this.commands.mustDo( Task.CHECK )
                               || this.commands.mustDo( Task.INSTALL );
    if( doCheckOrInstall ) {
      IUpdateSiteManager manager 
        = new UpdateSiteManager( this.configuration );
      boolean areFeaturesPresent 
        = manager.areFeaturesPresent( this.configuration.getRequiredFeatures() );
      if( areFeaturesPresent ) {
        if( this.commands.mustDo( Task.INSTALL ) ) {
          install( manager );
        }
        build();
      }
    } else {
      build();
    }
  }

  private void build() throws IOException, CoreException {
    if( this.commands.mustDo( Task.BUILD ) ) {
      MessageLogger.getInstance().logBeginProcess( "Application.Building" ); //$NON-NLS-1$
      IPackager packager = new EclipsePackager( this.configuration );
      packager.packApplication();
      PackageMover mover = new PackageMover( this.configuration );
      mover.moveFiles();
      MessageLogger.getInstance().logEndProcess();
    }
  }

  /**
   * Installs all requested features from the update sites to an extension
   * location. 
   */
  private void install( final IUpdateSiteManager manager )
    throws IOException, CoreException
  {
    MessageLogger.getInstance().logBeginProcess( "Application.Installing" ); //$NON-NLS-1$
    ExtensionSiteManager extensionSiteManager 
      = new ExtensionSiteManager( this.configuration );
    extensionSiteManager.installFeatures( manager );
    MessageLogger.getInstance().logEndProcess();
  }
}
