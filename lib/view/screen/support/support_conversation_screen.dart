import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/support_ticket_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/support_ticket_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_expanded_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_loader.dart';
import 'package:provider/provider.dart';

class SupportConversationScreen extends StatelessWidget {
  final SupportTicketModel supportTicketModel;
  SupportConversationScreen({@required this.supportTicketModel});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<SupportTicketProvider>(context, listen: false)
          .getSupportTicketReplyList(context, supportTicketModel.id);
    }

    return CustomExpandedAppBar(
      title: getTranslated('support_ticket_conversation', context),
      isGuestCheck: true,
      child: Column(children: [
        // Ticket Header Information
        Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: ColorResources.getImageBg(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: supportTicketModel.status == 'open'
                  ? ColorResources.getPrimary(context)
                  : Colors.grey,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      supportTicketModel.subject,
                      style: titilliumSemiBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL,
                      vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                    ),
                    decoration: BoxDecoration(
                      color: supportTicketModel.status == 'open'
                          ? ColorResources.getPrimary(context)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      supportTicketModel.status == 'open' ? 'OPEN' : 'CLOSED',
                      style: titilliumSemiBold.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: ColorResources.getPrimary(context),
                    size: 16,
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    'Created: ${DateConverter.localDateToIsoStringAMPM(DateTime.parse(supportTicketModel.createdAt))}',
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: Colors.grey[600]!!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Row(
                children: [
                  Icon(
                    Icons.category,
                    color: ColorResources.getPrimary(context),
                    size: 16,
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    'Type: ${supportTicketModel.type}',
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: Colors.grey[600]!!,
                    ),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Icon(
                    Icons.flag,
                    color: ColorResources.getPrimary(context),
                    size: 16,
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    'Priority: ${supportTicketModel.priority}',
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: Colors.grey[600]!!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(
                'Description: ${supportTicketModel.description}',
                style: titilliumRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                  color: Colors.grey[700]!!,
                ),
              ),
            ],
          ),
        ),

        Expanded(child:
        Consumer<SupportTicketProvider>(builder: (context, support, child) {
          return support.supportReplyList != null
              ? ListView.builder(
            itemCount: support.supportReplyList.length,
            reverse: true,
            itemBuilder: (context, index) {
              bool _isMe =
                  support.supportReplyList[index].customerMessage != null;
              String _message = _isMe
                  ? support.supportReplyList[index].customerMessage
                  : support.supportReplyList[index].adminMessage;
              String dateTime = DateConverter.localDateToIsoStringAMPM(
                  DateTime.parse(
                      support.supportReplyList[index].createdAt));

              return Container(
                margin: _isMe
                    ? EdgeInsets.fromLTRB(50, 5, 10, 5)
                    : EdgeInsets.fromLTRB(10, 5, 50, 5),
                padding:
                EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft:
                    _isMe ? Radius.circular(10) : Radius.circular(0),
                    bottomRight:
                    _isMe ? Radius.circular(0) : Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: _isMe
                      ? ColorResources.getImageBg(context)
                      : Theme.of(context).highlightColor,
                ),
                child: Column(
                    crossAxisAlignment: _isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(dateTime,
                          style: titilliumRegular.copyWith(
                            fontSize: 8,
                            color: ColorResources.getHint(context),
                          )),
                      _message != null
                          ? Text(_message,
                          style: titilliumRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL))
                          : SizedBox.shrink(),
                      //chat.image != null ? Image.file(chat.image) : SizedBox.shrink(),
                    ]),
              );
            },
          )
              : Center(
              child: CustomLoader(color: Theme.of(context).primaryColor));
        })),

        // Only show reply box for open tickets
        supportTicketModel.status == 'open'
            ? SizedBox(
          height: 70,
          child: Card(
            color: Theme.of(context).highlightColor,
            shadowColor: Colors.grey[200]!!,
            elevation: 2,
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: titilliumRegular,
                    keyboardType: TextInputType.multiline,
                    maxLines: null
                    expands: true,
                    decoration: InputDecoration(
                      hintText: getTranslated('type_here', context),
                      hintStyle: titilliumRegular.copyWith(
                          color: ColorResources.HINT_TEXT_COLOR),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (_controller.text.isNotEmpty) {
                      Provider.of<SupportTicketProvider>(context,
                          listen: false)
                          .sendReply(context, supportTicketModel.id ?? 0,
                          _controller.text);
                      _controller.text = '';
                    } else {}
                  },
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                    size: Dimensions.ICON_SIZE_DEFAULT,
                  ),
                ),
              ]),
            ),
          ),
        )
            : Container(
          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          decoration: BoxDecoration(
            color: Colors.grey[100]!!,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lock,
                color: Colors.grey[600]!!,
                size: 20,
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(
                child: Text(
                  'This ticket is closed. You cannot add new replies.',
                  style: titilliumRegular.copyWith(
                    color: Colors.grey[600]!!,
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
