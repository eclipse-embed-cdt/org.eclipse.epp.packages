/*******************************************************************************
 * Copyright (c) 2007, 2008 Innoopract Informationssysteme GmbH
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
import java.net.URISyntaxException;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.Status;
import org.eclipse.epp.packaging.core.configuration.ArgumentParser;
import org.eclipse.epp.packaging.core.configuration.ICommands;
import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.xml.ConfigurationParser;
import org.eclipse.equinox.app.IApplication;
import org.eclipse.equinox.app.IApplicationContext;
import org.xml.sax.SAXException;

/**
 * Main entry point for the EPP packager.
 */
public class PackagingApplication implements IApplication {

  private static final Integer EXIT_ERROR = new Integer( 1 );

  public Object start( final IApplicationContext context ) {
    Map<?, ?> arguments = context.getArguments();
    String[] args = ( String[] )arguments.get( IApplicationContext.APPLICATION_ARGS );
    ICommands commands = ArgumentParser.parse( args );
    ConfigurationParser configurationParser 
      = new ConfigurationParser( commands.getConfigurationFile() );
    IPackagerConfiguration configuration;
    try {
      configuration = configurationParser.parseConfiguration();
    } catch( SAXException saxEx ) {
      logError( saxEx, "Could not parse configuration file." ); //$NON-NLS-1$
      return EXIT_ERROR;
    } catch( IOException ioEx ) {
      logError( ioEx, "Could not read configuration file." ); //$NON-NLS-1$
      return EXIT_ERROR;
    } catch( ParserConfigurationException parserConfigEx ) {
      logError( parserConfigEx, "XML parser configuration error." ); //$NON-NLS-1$
      return EXIT_ERROR;
    }
    IStatus checkFeaturesResult;
    try {
      checkFeaturesResult = configuration.checkFeatures( new NullProgressMonitor() );
    } catch( CoreException coreEx ) {
      logError( coreEx, "Features with error." ); //$NON-NLS-1$
      return EXIT_ERROR;
    }
    
    IStatus[] status = checkFeaturesResult.getChildren();
    for( IStatus singleStatus : status ) {
      System.out.println( singleStatus.getMessage() );
    }  
    
    if( checkFeaturesResult.getSeverity() == IStatus.OK
        || checkFeaturesResult.getSeverity() == IStatus.INFO
        || checkFeaturesResult.getSeverity() == IStatus.WARNING )
    {
      EclipsePackagingExecutor packagingExecutor 
        = new EclipsePackagingExecutor( commands, configuration );
      try {
        packagingExecutor.execute();
      } catch( CoreException coreEx ) {
        logError( coreEx, "Could not build package." ); //$NON-NLS-1$
        return EXIT_ERROR;
      } catch( IOException ioEx ) {
        logError( ioEx, "I/O exception during package build." ); //$NON-NLS-1$
        return EXIT_ERROR;
      } catch( URISyntaxException uriSyntaxEx ) {
        logError( uriSyntaxEx, "Malformed URI." ); //$NON-NLS-1$
        return EXIT_ERROR;
      }
    }
    return EXIT_OK;
  }

  public void stop() {
    // nothing to stop here...
  }

  private void logError( final Exception exception, final String message ) {
    IStatus status = new Status( IStatus.ERROR,
                                 Activator.PLUGIN_ID,
                                 message,
                                 exception );
    Activator.getDefault().getLog().log( status );
  }
}
