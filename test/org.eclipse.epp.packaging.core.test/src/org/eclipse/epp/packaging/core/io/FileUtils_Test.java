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

import org.eclipse.epp.packaging.core.io.FileUtils;

import junit.framework.Assert;
import junit.framework.TestCase;

/** Test class */
public class FileUtils_Test extends TestCase {

  public void testFileIsCopied() throws Exception {
    FileUtils.copy( "./resources/test/singleentryfile", //$NON-NLS-1$
                    "./resources/test/copy" ); //$NON-NLS-1$
    Assert.assertTrue( new File( "./resources/test/copy" ).exists() ); //$NON-NLS-1$
  }

  public void testCopyFileDirectly() throws Exception {
    FileUtils.copy( new File( "./resources/test/singleentryfile" ), //$NON-NLS-1$
                    new File( "./resources/test/copy" ) ); //$NON-NLS-1$
    Assert.assertTrue( new File( "./resources/test/copy" ).exists() ); //$NON-NLS-1$
  }

  public void testDirectoryIsCreated() throws Exception {
    FileUtils.copy( "./resources/test/singleentryfile", //$NON-NLS-1$
                    "./resources/test/copy/copy" ); //$NON-NLS-1$
    Assert.assertTrue( new File( "./resources/test/copy/copy" ).exists() ); //$NON-NLS-1$
    new File( "./resources/test/copy/copy" ).delete(); //$NON-NLS-1$
  }

  @Override
  protected void tearDown() throws Exception
  {
    new File( "./resources/test/copy" ).delete(); //$NON-NLS-1$
  }
}
