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
package org.eclipse.epp.packaging.core.configuration.xml;

/** An XML Element with sub elements and attributes. */
public interface IXmlElement {

  /**
   * Returns all descendant elements of this element whose name equals the given
   * name.
   */
  public IXmlElement[] getElements( String tagName );

  /**
   * Returns the value of the given attribute.
   */
  public String getAttributeValue( String attributeName );

  /**
   * Returns the first descendant element of the given name or <code>null</code>,
   * if none exist.
   */
  public IXmlElement getElement( String tagName );
}
