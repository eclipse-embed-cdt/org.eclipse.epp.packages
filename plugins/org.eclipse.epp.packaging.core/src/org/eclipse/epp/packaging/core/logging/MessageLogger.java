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

/**
 * Combines logging and i18n into a single class.
 */
public class MessageLogger {

  private final static MessageLogger instance = new MessageLogger();
  private final Logger logger = new Logger();

  public static MessageLogger getInstance() {
    return instance;
  }

  public void log( final String messageKey ) {
    logger.log( getI18nedMessage( messageKey ) );
  }

  public void log( final String messageKey, final Object argument ) {
    logger.log( getI18nedMessage( messageKey, argument ) );
  }

  public void logBeginProcess( final String messageKey ) {
    logger.logBeginProcess( getI18nedMessage( messageKey ) );
  }

  public void logBeginProcess( final String messageKey, final Object argument )
  {
    logger.logBeginProcess( getI18nedMessage( messageKey, argument ) );
  }


  private String getI18nedMessage( final String message ) {
    return Messages.getString( message );
  }

  private String getI18nedMessage( final String messageKey,
                                   final Object argument )
  {
    return Messages.getString( messageKey, argument );
  }
  
  public void logEndProcess() {
    logger.logEndProcess(Messages.getString( "Logger.Done" )); //$NON-NLS-1$
  }

  public void logEndProcess( final String messageKey ) {
    logger.logEndProcess( getI18nedMessage( messageKey ) );
  }

  public void logEndProcess( final String messageKey, final Object argument ) {
    logger.logEndProcess( getI18nedMessage( messageKey, argument ) );
  }
}