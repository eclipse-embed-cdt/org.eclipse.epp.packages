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

/**
 * Enumerates the archive formats. "antTar" will not be available until
 * http://issues.apache.org/bugzilla/show_bug.cgi?id=39617 and
 * https://bugs.eclipse.org/bugs/show_bug.cgi?id=142792 are fixed.
 */
public enum ArchiveFormat {
  tar {

    @Override
    public String getExtension()
    {
      return ".tar.gz"; //$NON-NLS-1$
    }
  },
  
  antZip {

    @Override
    public String getExtension()
    {
      return ".zip"; //$NON-NLS-1$
    }
  };

  public abstract String getExtension();
}