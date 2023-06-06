//
//  TermsConditionVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/9/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class TermsConditionVC: UIViewController {
    
    @IBOutlet weak var textHeaderLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var page: Pages = .terms
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if page == .terms {
            textHeaderLbl.text = "Terms & Conditions"
            textView.text = """
"Terms and conditions "
    1.Terms"
     By accessing our app, beautesoft hr, you are agreeing to be bound by these terms of service, all applicable "
        "laws and regulations, and agree that you are responsible for compliance with any applicable local laws. "
        "If you do not agree with any of these terms, you are prohibited from using or accessing beautesoft hr. The materials contained "
        "in beautesoft hr are protected by applicable copyright and trademark law."
    2.Use License"
             Permission is granted to temporarily download one copy of beautesoft hr per device for personal, non-commercial "
        "transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:"
         modify or copy the materials;"
          use the materials for any commercial purpose, or for any public display (commercial or non-commercial);"
          attempt to decompile or reverse engineer any software contained in beautesoft hr;"
          remove any copyright or other proprietary notations from the materials; or"
          transfer the materials to another person or \"mirror\" the materials on any other server."
          This license shall automatically terminate if you violate any of these restrictions and may be terminated by sequoia at any time. "
        "Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your "
        "possession whether in electronic or printed format."
    3.Disclaimer"
             The materials within beautesoft hr are provided on an 'as is' basis. sequoia makes no warranties, expressed or implied, and hereby "
        "disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a "
        "particular purpose, or non-infringement of intellectual property or other violation of rights."
             Further, sequoia does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of "
        "the materials on its website or otherwise relating to such materials or on any sites linked to beautesoft hr."
    4.Limitations"
             In no event shall sequoia or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, "
        "or due to business interruption) arising out of the use or inability to use beautesoft hr, even if sequoia or a sequoia authorized representative "
        "has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, "
        "or limitations of liability for consequential or incidental damages, these limitations may not apply to you."
    5.Accuracy of materials"
             The materials appearing in beautesoft hr could include technical, typographical, or photographic errors. sequoia does not warrant that any of "
        "the materials on beautesoft hr are accurate, complete or current. sequoia may make changes to the materials contained in beautesoft hr at any time "
        "without notice. However sequoia does not make any commitment to update the materials."
    6.Links"
             sequoia has not reviewed all of the sites linked to its app and is not responsible for the contents of any such linked site. The inclusion "
        "of any link does not imply endorsement by sequoia of the site. Use of any such linked website is at the user's own risk."
    7.Modifications"
             sequoia may revise these terms of service for its app at any time without notice. By using beautesoft hr you are agreeing to be bound by "
        "the then current version of these terms of service."
    8.Governing Law"
             These terms and conditions are governed by and construed in accordance with the laws of 50 Serangoon North Ave 4, #09-12 First Centre, "
        "Singapore 555856 and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location."
         "
    9. In case of a dispute, the Company reserves the right of final decision on the interpretation of these Terms and Conditions."
"""
        } else if page == .privacyPolicy {
            textHeaderLbl.text = "Privacy Policy"
            textView.text = """
"Privacy Policy "
Sequoia built the beautesoft-hr app as a Commercial app. This SERVICE is provided by Sequoia and is intended for use as is. "
 This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service."
 If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. "
 "The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with "
 "anyone except as described in this Privacy Policy."
 The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at beautesoft-hr "
 "unless otherwise defined in this Privacy Policy."

Information Collection and Use"
For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information. "
 "The information that we request will be retained by us and used as described in this privacy policy."
 The app does use third party services that may collect information used to identify you."
 Link to privacy policy of third party service providers used by the app "

• Google Play Services"
 Log Data"
We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information "
 "(through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet "
 "Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time "
 "and date of your use of the Service, and other statistics."

Cookies"
Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent "
 "to your browser from the websites that you visit and are stored on your device's internal memory."
 This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” "
 "to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie "
 "is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service. "

Service Providers"
 We may employ third-party companies and individuals due to the following reasons:"
 • To facilitate our Service;"
 • To provide the Service on our behalf;"
 • To perform Service-related services;"
 • To assist us in analyzing how our Service is used."
 We want to inform users of this Service that these third parties have access to your Personal Information. The reason is "
 "to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose. "
 Security"
 We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable "
 "means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% "
 "secure and reliable, and we cannot guarantee its absolute security. "

Links to Other Sites"
 This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. "
 "Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. "
 "We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services. "
 Changes to This Privacy Policy"

   We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. "
 "We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are "
 "posted on this page. "

Contact Us"
 If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at +65 9320 6162 +(601) 2207 – 1351 +(603) 7710 – 6390."
"""
        } else {
            textHeaderLbl.text = "Help"
            textView.text = """
"Dummy text: Its function as a filler or as a tool for comparing the visual impression of different typefaces
Dummy text is text that is used in the publishing industry or by web designers to occupy the space which will later be filled with 'real' content. This is required when, for example, the final text is not yet available. Dummy text is also known as 'fill text'. It is said that song composers of the past used dummy texts as lyrics when writing melodies in order to have a 'ready-made' text to sing with the melody. Dummy texts have been in use by typesetters since the 16th century.

The usefulness of nonsensical content
Dummy text is also used to demonstrate the appearance of different typefaces and layouts, and in general the content of dummy text is nonsensical. Due to its widespread use as filler text for layouts, non-readability is of great importance: human perception is tuned to recognize certain patterns and repetitions in texts. If the distribution of letters and 'words' is random, the reader will not be distracted from making a neutral judgement on the visual impact and readability of the typefaces (typography), or the distribution of text on the page (layout or type area). For this reason, dummy text usually consists of a more or less random series of words or syllables. This prevents repetitive patterns from impairing the overall visual impression and facilitates the comparison of different typefaces. Furthermore, it is advantageous when the dummy text is relatively realistic so that the layout impression of the final publication is not compromised."/>

"""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
