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

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

/**
 * An XML document based on W3C DOM with a description of the EPP package.
 */
public class XMLDocument {

  private final Document document;

  /**
   * Creates a new instance of the XMLDocument from an input file.
   * 
   * @param xmlFile the EPP configuration file
   * @throws SAXException if the file cannot be parsed
   * @throws IOException if the file cannot be read or parsed
   * @throws ParserConfigurationException if the document builder cannot be
   *             created
   */
  public XMLDocument( final File xmlFile )
    throws SAXException, IOException, ParserConfigurationException
  {
    DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
    DocumentBuilder documentBuilder = docBuilderFactory.newDocumentBuilder();
    this.document = documentBuilder.parse( xmlFile );
  }

  /**
   * Creates a new instance of the XMLDocument from an XML input string.
   * 
   * @param xmlString the string containing the EPP configuration
   * @throws SAXException if the file cannot be parsed
   * @throws IOException if the file cannot be read or parsed
   * @throws ParserConfigurationException if the document builder cannot be
   *             created
   */
  public XMLDocument( final String xmlString )
    throws SAXException, IOException, ParserConfigurationException
  {
    DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
    DocumentBuilder documentBuilder = docBuilderFactory.newDocumentBuilder();
    ByteArrayInputStream inputStream = new ByteArrayInputStream( xmlString.getBytes() );
    this.document = documentBuilder.parse( inputStream );
  }

  /**
   * Returns the root element (<code>configuration</code> element) of the EPP
   * XML configuration.
   * 
   * @return the root element of this document
   */
  public IXmlElement getRootElement() {
    return new XmlElement( ( Element )this.document.getFirstChild() );
  }
}