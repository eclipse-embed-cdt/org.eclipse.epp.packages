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
   * @throws IllegalArgumentException if arguments is no array of strings.
   */
  public static ICommands parse( final Object arguments ) {
    String[] strings;
    try {
      strings = ( String[] )arguments;
    } catch( ClassCastException exception ) {
      throw new IllegalArgumentException( "Arguments must be an array of String.", exception ); //$NON-NLS-1$
    }
    Commands command = new Commands();
    command.setConfigurationFile( strings[ 0 ] );
    if( strings.length > 1 ) {
      String[] tasks = new String[ strings.length - 1 ];
      System.arraycopy( strings, 1, tasks, 0, tasks.length );
      command.setTasks( tasks );
    }
    return command;
  }
}