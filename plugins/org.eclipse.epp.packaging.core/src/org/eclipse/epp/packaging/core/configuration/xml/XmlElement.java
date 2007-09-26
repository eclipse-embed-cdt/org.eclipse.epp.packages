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

import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

/** XML Element implementation using an underlying W3C DOM Element. */
public class XmlElement implements IXmlElement {

  private final Element node;

  public XmlElement( final Element node ) {
    this.node = node;
  }

  public String getAttributeValue( final String attributeName ) {
    return node.getAttribute( attributeName );
  }

  public IXmlElement getElement( final String tagName ) {
    NodeList elementsByTagName = node.getElementsByTagName( tagName );
    IXmlElement result;
    if( elementsByTagName.getLength() == 0 ) {
      result = null;
    } else {
      result = new XmlElement( ( Element )elementsByTagName.item( 0 ) );
    }
    return result;
  }

  public IXmlElement[] getElements( final String tagName ) {
    NodeList elementsByTagName = node.getElementsByTagName( tagName );
    List<IXmlElement> result = new ArrayList<IXmlElement>();
    for( int index = 0; index < elementsByTagName.getLength(); index++ ) {
      result.add( new XmlElement( ( Element )elementsByTagName.item( index ) ) );
    }
    return result.toArray( new IXmlElement[ result.size() ] );
  }

  public String getText() {
    return this.node.getTextContent();
  }
}