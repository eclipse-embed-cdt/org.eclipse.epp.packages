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

import org.eclipse.core.runtime.IPlatformRunnable;
import org.eclipse.epp.packaging.core.configuration.ArgumentParser;
import org.eclipse.epp.packaging.core.configuration.ICommands;
import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.xml.ConfigurationParser;

/**
 * Main entry point for the EPP packager.
 */
public class Application implements IPlatformRunnable {

  /**
   * Runs the Eclipse Packager. args is expected to be a conventional String
   * array. The first entry must hold the location of the configuration
   * properties file.
   */
  public Object run( final Object args ) throws Exception {
    ICommands commands = ArgumentParser.parse( args );
    IPackagerConfiguration configuration = new ConfigurationParser().parseConfiguration( commands.getConfigurationFile() );
    new EclipsePackagingExecutor( commands, configuration ).execute();
    return EXIT_OK;
  }
}