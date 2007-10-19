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
package org.eclipse.epp.packaging.core.configuration;

/**
 * Parses the arguments given to the main application.
 */
public class ArgumentParser {

  /**
   * @param args the argument vector as a String array
   * @return an initialised <code>ICommand</code> object with the parsed
   *         command line options
   * @throws IllegalArgumentException if arguments is no array of strings.
   */
  public static ICommands parse( final String[] args ) {
    if( args == null || args.length == 0 ) {
      throw new IllegalArgumentException( "Argument must contain at least one value." ); //$NON-NLS-1$
    }
    Commands command = new Commands();
    command.setConfigurationFile( args[ 0 ] );
    if( args.length > 1 ) {
      String[] tasks = new String[ args.length - 1 ];
      System.arraycopy( args, 1, tasks, 0, tasks.length );
      command.setTasks( tasks );
    }
    return command;
  }
}