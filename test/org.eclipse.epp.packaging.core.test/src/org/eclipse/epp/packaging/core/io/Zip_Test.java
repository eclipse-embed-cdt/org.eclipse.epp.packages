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
package org.eclipse.epp.packaging.core.io;

import java.io.File;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import junit.framework.Assert;
import junit.framework.TestCase;

import org.eclipse.epp.packaging.core.io.Zip;

/** Test class */
public class Zip_Test extends TestCase {

  private static final String TEST_ZIP_PATH 
    = "./resources/test/test.zip"; //$NON-NLS-1$
  private Zip zip = null;

  @Override
  protected void setUp() throws Exception
  {
    this.zip = new Zip( new File( TEST_ZIP_PATH ) );
  }

  public void testCreateZipFile() throws Exception {
    this.zip.addFile( "./resources/test/singleentryfile" ); //$NON-NLS-1$
    this.zip.close();
    Assert.assertTrue( new File( TEST_ZIP_PATH ).exists() );
  }

  public void testAddFile() throws Exception {
    this.zip.addFile( "./resources/test/singleentryfile" ); //$NON-NLS-1$
    this.zip.close();
    ZipFile zipFile = new ZipFile( TEST_ZIP_PATH );
    ZipEntry entry = zipFile.getEntry( "resources/test/singleentryfile" ); //$NON-NLS-1$
    Assert.assertNotNull( entry );
  }

  // TODO test fails sometimes when not in debug mode... timing problem?
  public void testAddFolder() throws Exception {
    this.zip.addFolder( new File( "./resources/test/updatesite/features" ) ); //$NON-NLS-1$
    this.zip.close();
    ZipFile zipFile = new ZipFile( TEST_ZIP_PATH );
    ZipEntry entry = zipFile.getEntry( "org.eclipse.buckminster.core.feature_1.0.0.v20070205.jar" ); //$NON-NLS-1$
    Assert.assertNotNull( entry );
  }

  // TODO test fails sometimes when not in debug mode... timing problem?
  public void testAddFileAs() throws Exception {
    File testFile = new File( "./resources/test/singleentryfile" ); //$NON-NLS-1$
    this.zip.addFileAs( testFile, "eclipse/configuration/config.ini" ); //$NON-NLS-1$
    this.zip.close();
    ZipEntry entry = new ZipFile( TEST_ZIP_PATH ).getEntry( "eclipse/configuration/config.ini" ); //$NON-NLS-1$
    Assert.assertNotNull( entry );
  }

  @Override
  protected void tearDown() throws Exception
  {
    new File( TEST_ZIP_PATH ).delete();
  }
}
