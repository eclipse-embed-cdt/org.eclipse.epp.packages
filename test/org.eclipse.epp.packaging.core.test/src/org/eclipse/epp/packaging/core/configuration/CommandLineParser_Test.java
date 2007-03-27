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

import junit.framework.Assert;
import junit.framework.TestCase;

/** Test class */
public class CommandLineParser_Test extends TestCase {

  public void testParsesConfigFile() throws Exception {
    ICommands command = ArgumentParser.parse( new String[]{
      "eclipsepackager.xml"} ); //$NON-NLS-1$
    Assert.assertEquals( "eclipsepackager.xml", command.getConfigurationFile().getName() ); //$NON-NLS-1$
  }

  public void testDefaultTasks() {
    ICommands command = ArgumentParser.parse( new String[]{
      "eclipsepackager.xml"} ); //$NON-NLS-1$
    Assert.assertTrue( command.mustDo( Task.CHECK ) );
    Assert.assertTrue( command.mustDo( Task.INSTALL ) );
    Assert.assertTrue( command.mustDo( Task.BUILD ) );
  }

  public void testParsesTasks() throws Exception {
    ICommands command = ArgumentParser.parse( new String[]{
      "eclipsepackager.xml", "check", "install"} ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    Assert.assertTrue( command.mustDo( Task.CHECK ) );
    Assert.assertTrue( command.mustDo( Task.INSTALL ) );
  }

  public void testParsesAllTasks() throws Exception {
    ICommands command = ArgumentParser.parse( new String[]{
      "eclipsepackager.xml", "check", "install", "build"} ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$
    Assert.assertTrue( command.mustDo( Task.CHECK ) );
    Assert.assertTrue( command.mustDo( Task.INSTALL ) );
    Assert.assertTrue( command.mustDo( Task.BUILD ) );
  }

  public void testBadArgumentType() throws Exception {
    try {
      ArgumentParser.parse( Boolean.TRUE );
      fail();
    } catch( IllegalArgumentException e ) {
      // expected exception
    }
  }
}