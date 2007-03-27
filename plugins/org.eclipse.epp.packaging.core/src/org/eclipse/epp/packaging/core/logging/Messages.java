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

import java.text.MessageFormat;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

/** Utility class providing basic internationalization facilities. */
public class Messages {

  private static final String BUNDLE_NAME = "org.eclipse.epp.packaging.core.logging.messages"; //$NON-NLS-1$
  private static final ResourceBundle RESOURCE_BUNDLE = ResourceBundle.getBundle( BUNDLE_NAME );

  private Messages() {
    // private constructor
  }

  /**
   * Returns the value associated with the given key, or a placeholder if the
   * key does not exist.
   */
  public static String getString( final String key ) {
    String result;
    try {
      result = RESOURCE_BUNDLE.getString( key );
    } catch( MissingResourceException e ) {
      result = '!' + key + '!';
    }
    return result;
  }

  /**
   * Returns the value associated with the given key, using it as a message.
   * 
   * @param key An internationalization key defined in a resource file. Should
   *          denote a message.
   * @param argument The argument to insert into the message.
   */
  public static String getString( final String key, final Object argument ) {
    Object[] messageArgument = {
      argument
    };
    MessageFormat formatter = new MessageFormat( "" ); //$NON-NLS-1$
    formatter.applyPattern( getString( key ) );
    String output = formatter.format( messageArgument );
    return output;
  }
}
