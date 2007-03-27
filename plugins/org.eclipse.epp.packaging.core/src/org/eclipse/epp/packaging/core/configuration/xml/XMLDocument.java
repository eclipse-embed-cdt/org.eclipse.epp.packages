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

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

/** An XML document based on W3C DOM */
public class XMLDocument {

  private final Document document;

  public XMLDocument( final File xmlFile )
    throws SAXException, IOException, ParserConfigurationException
  {
    this.document = DocumentBuilderFactory.newInstance()
      .newDocumentBuilder()
      .parse( xmlFile );
  }

  /** @param A string with XML data */
  public XMLDocument( final String xmlString )
    throws SAXException, IOException, ParserConfigurationException
  {
    this.document = DocumentBuilderFactory.newInstance()
      .newDocumentBuilder()
      .parse( new ByteArrayInputStream( xmlString.getBytes() ) );
  }

  /** Returns the root element of this document. */
  public IXmlElement getRootElement() {
    return new XmlElement( ( Element )document.getFirstChild() );
  }
}