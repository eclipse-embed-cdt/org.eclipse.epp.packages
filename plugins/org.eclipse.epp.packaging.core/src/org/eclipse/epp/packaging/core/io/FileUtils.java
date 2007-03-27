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
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;

/**
 * Utility class for file operation.
  */
public class FileUtils {

  /**
   * Copies source to destination.
   * 
   * @param source The source file.
   * @param destination The destination file.
   */
  public static void copy( final File source, final File destination )
    throws IOException
  {
    if( !source.exists() ) {
      return;
    }
    createDestinationFolder( destination );
    FileChannel inputChannel = null;
    FileChannel outputChannel = null;
    try {
      inputChannel = new FileInputStream( source ).getChannel();
      outputChannel = new FileOutputStream( destination ).getChannel();
      inputChannel.transferTo( 0, inputChannel.size(), outputChannel );
    } finally {
      if( inputChannel != null ) {
        inputChannel.close();
      }
      if( outputChannel != null ) {
        outputChannel.close();
      }
    }
  }

  /**
   * Copies source to destination.
   * 
   * @param source Path to the source file.
   * @param destination Path to the destination file.
   */
  public static void copy( final String source, final String destination )
    throws IOException
  {
    File sourceFile = new File( source );
    copy( sourceFile, new File( destination ) );
  }

  /** Creates parent folders, if not existing. */
  private static void createDestinationFolder( final File destinationFile ) {
    File destinationParent = destinationFile.getParentFile();
    if( !destinationParent.exists() ) {
      destinationParent.mkdirs();
    }
  }

  /** Recursively deletes a file or folder. */
  public static void deleteFile( final File file ) {
    if( file.isDirectory() ) {
      for( File subFile : file.listFiles() ) {
        deleteFile( subFile );
      }
    }
    file.delete();
  }
}