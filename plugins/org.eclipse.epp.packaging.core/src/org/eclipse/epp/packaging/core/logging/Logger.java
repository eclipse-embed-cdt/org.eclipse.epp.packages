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
package org.eclipse.epp.packaging.core.logging;

import java.util.HashMap;
import java.util.Map;

/**
 * A logger with basic process handling facilities.
 */
public class Logger {

  private int processCount = 0;
  private Map<Integer, Boolean> subProcesses = new HashMap<Integer, Boolean>();
  private boolean justEndedProcess = false;

  /** Log a single event */
  public void log( final String message ) {
    createNewEntry( message );
    justEndedProcess = true;
  }

  /** Log the beginning of an ongoing process. */
  public void logBeginProcess( final String message ) {
    createNewEntry( message );
    System.out.print( "..." );//$NON-NLS-1$
    processCount++;
    memorizeProcess( Boolean.FALSE );
    justEndedProcess = false;
  }

  private void createNewEntry( final String message ) {
    memorizeProcess( Boolean.TRUE );
    System.out.println();
    indent();
    System.out.print( message );
  }

  private void memorizeProcess( final Boolean value ) {
    subProcesses.put( getProcessCount(), value );
  }

  /** Indent to indicate sub-processes. */
  private void indent() {
    for( int index = 0; index < processCount; index++ ) {
      System.out.print( "  " ); //$NON-NLS-1$
    }
  }

  public void logEndProcess( final String message ) {
    if( processCount > 0 ) {
      if( justEndedProcess ) {
        System.out.println();
      }
      boolean booleanValue = subProcesses.get( getProcessCount() )
        .booleanValue();
      processCount--;
      if( booleanValue ) {
        indent();
      }
      System.out.print( message );
      justEndedProcess = true;
    }
  }

  private Integer getProcessCount() {
    return Integer.valueOf( processCount );
  }
}