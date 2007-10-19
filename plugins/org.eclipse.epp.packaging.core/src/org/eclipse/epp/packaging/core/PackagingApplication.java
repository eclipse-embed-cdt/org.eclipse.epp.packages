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

import java.util.Map;

import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.epp.packaging.core.configuration.ArgumentParser;
import org.eclipse.epp.packaging.core.configuration.ICommands;
import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.xml.ConfigurationParser;
import org.eclipse.equinox.app.IApplication;
import org.eclipse.equinox.app.IApplicationContext;

/**
 * Main entry point for the EPP packager.
 */
public class PackagingApplication implements IApplication {

  public Object start( final IApplicationContext context ) throws Exception {
    Map<?, ?> arguments = context.getArguments();
    String[] args = ( String[] )arguments.get( IApplicationContext.APPLICATION_ARGS );
    ICommands commands = ArgumentParser.parse( args );
    ConfigurationParser configurationParser 
      = new ConfigurationParser( commands.getConfigurationFile() );
    IPackagerConfiguration configuration 
      = configurationParser.parseConfiguration();
    IStatus checkFeaturesResult 
      = configuration.checkFeatures( new NullProgressMonitor() );
    
    IStatus[] status = checkFeaturesResult.getChildren();
    for( IStatus singleStatus : status ) {
      System.out.println( singleStatus.getMessage() );
    }  
    
    if(    checkFeaturesResult.getSeverity() == IStatus.OK
        || checkFeaturesResult.getSeverity() == IStatus.INFO 
        || checkFeaturesResult.getSeverity() == IStatus.WARNING ) {
      EclipsePackagingExecutor packagingExecutor 
        = new EclipsePackagingExecutor( commands, configuration );
      packagingExecutor.execute();
    }
    return EXIT_OK;
  }

  public void stop() {
    // nothing to stop here...
  }
}